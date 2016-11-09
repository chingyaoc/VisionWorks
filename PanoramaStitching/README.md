<center>
<img src="./index_files/AllStitched.png" width="410" >
<br>
(Panorama image of Mt. Rainer in Washington USA.)
</center>

# Project 2: Panorama Stitching

## Brief
* Due: Nov. 9
* Required files: results/index.md, and code/

##Overview
Panoramic stitching is an early success of computer vision. Matthew Brown and David G. Lowe published a famous [panoramic image stitching paper](http://www.cs.ubc.ca/~lowe/papers/07brown.pdf) in 2007. Since then, automatic panorama stitching technology has been widely adopted in many applications such as Google Street View, panorama photos on smartphones, and stitching software such as [Photosynth](http://photosynth.net/) and [AutoStitch](http://cs.bath.ac.uk/brown/autostitch/autostitch.html).

In this programming assignment, we will match SIFT keypoints from multiple images to build a single panoramic image. This will involve several tasks:

* Detect SIFT points and extract SIFT descriptor for each keypoint in an image using vlfeat.


* Compare two sets of SIFT descriptors coming from two different images and find matching keypoints (`SIFTSimpleMatcher.m`).


* Given a list of matching keypoints, use least-square method to find the affine transformation matrix that maps positions in image 1 to positions in image 2 (`ComputeAffineMatrix.m`).


* Use RANSAC to give a more robust estimate of affine transformation matrix (`RANSACFit.m`).


* Given that transformation matrix, use it to transform (shift, scale, or skew) image 1 and overlay it on top of image 2, forming a panorama. (This is done for you.)
<center>
<img src="./index_files/Rainier1.png" width="200" >
<img src="./index_files/Rainier2.png" width="200" >
<br>
(Left: image 1 & Right: image 2)
<br>
<img src="./index_files/Stitched.png" width="410" >
<br>
(Stitched image)
</center>

* Stitch multiple images together under a simplified case of real-world scenario ('MultipleStitch.m').

##Details
Now we give details of each step:

### Get SIFT points and descriptors
Download [VLFeat 0.9.17 binary package](http://www.vlfeat.org/download.html). We are only using the `vl_sift` function. VL Feat Matlab reference: [http://www.vlfeat.org/matlab/matlab.html](http://www.vlfeat.org/matlab/matlab.html)

### Matching SIFT Descriptors 
Edit `SIFTSimpleMatcher.m` to calculate the Euclidean distance between a given SIFT descriptor from im- age 1 and all SIFT descriptors from image 2. Then use this to determine if there’s a good match: if the distance to the closest vector is significantly (by a factor which is given) smaller than the distance to the second-closest, we call it a match. The output of the function is an array where each row holds the indices of one pair of matching descriptors.

Run the provided `EvaluateSIFTMatcher.m` to check your implementation. You can also use `PlotMatch.m` to visualize the matches.

Hints: Remember, Euclidean distance between vectors \\(a\in R^n\\) and \\(b\in R^n\\) is
\\[
\sqrt{(a[1]-b[1])^2+(a[2]-b[2])^2+...+(a[n]-b[n])^2}
\\]
You can calculate this entirely with matrix math if you use the `repmat` command. 


### Fitting the Transformation Matrix
We now have a list of matched keypoints across the two images! We will use this to find a transformation
matrix that maps an image 1 point to the corresponding coordinates in image 2. In other words, if the point
\\([x_1, y_1]\\) in image 1 matches with \\([x_2, y_2]\\) in image 2, we need to find a transformation matrix H such that
\\[
[x_2 y_2 1] = [x_1 y_1 1]H'
\\]
With a sufficient number of points, MATLAB can solve for the best H for us. Edit `ComputeAffineMatrix.m` to calculate H given the list of matching points. Run the provided `EvaluateAffineMatrix.m` to check your implementation.

Hints: 1. MATLAB “backslash” command.

### RANSAC
Rather than directly feeding all of our SIFT keypoint matches into `ComputeAffineMatrix.m`, we will use RANSAC (“RANdom SAmple Consensus”) to select only “inliers” to use to compute the transformation matrix. In this case, inliers are pairs whose relationship is described by the same transformation matrix. We have implemented RANSAC for you, except for the cost function which determines how well two points are related by a given matrix H. Edit the `ComputeError()` function in `RANSACFit.m` to find the Euclidean distance between Hp1 and p2:

\\[
\||[x_2 y_2 1] - [x_1 y_1 1]H'\||_2
\\]

where \\(\|| \;\||_2\\) is the Euclidean distance, as defined above. After you finish `RANSACFit.m`, you can test your code by running `TransformationTester.m`.

### Stitching Multiple Images
#### Stitching ordered sequence of images
We have provided a function which uses the code you have written to efficiently stitch an set of images of Mt. Rainer in Washington USA.

Given a sequence of m images (e.g., yosemite*.jpg)
\\[
Img_1, Img_2,...,Img_m
\\]

our code takes every neighboring pair of images and computes the transformation matrix which converts points from the coordinate frame of \\(Img_i\\) to the frame of \\(Img_{i+1}\\). (It does this by simply calling your code on each pair.)
We then select a reference image \\(Img_r\\). We want our final panorama image to be in the coordinate frame of \\(Img_r\\). So, for each \\(Img_i\\) that is not the reference image, we need
a transformation matrix that will convert points in frame i to frame ref. (MATLAB can then take this transformation matrix and transform the images for us.)
Your task is to implement the function `makeTransformToReferenceFrame` in `MultipleStitch.m`. You are given the list of matrices which convert each frame i to frame i+1. You must use these matrices to construct a matrix which will convert the given frame into the given reference frame.

Hints: The inverse of a transformation matrix has the reverse effect. Please use Matlab’s pinv function
whenever you want to compute matrix inverse. pinv is more robust than inv.

After finishing this part, you can check your code by running `StitchTester.m`. 

#### Stitching unordered sequence of images (extra credit)
Given an unordered set of m images (e.g., Rainier*.jpg), how can we find the 1. reference image, and 2 the most robust transformation to the reference image (bundle adjustment).

Hint: described in [panoramic image stitching paper](http://www.cs.ubc.ca/~lowe/papers/07brown.pdf). You are allow to use 3rd party code as long as you mention it in your report.

## Extra Points
* +2 pts: If you make your code publicly available.
* +2 pts: If you comment on pull request from students who fork the homework.
* +5 pts: If you Stitching unordered sequence of images.
* +2 pts: Impressive panorama examples.

## Writeup
For this project, and all other projects, you must do a project report in results folder using [Markdown](https://help.github.com/articles/markdown-basics). We provide you with a placeholder [index.md](./results/index.md) document which you can edit. In the report you will describe your algorithm and any decisions you made to write your algorithm a particular way. Then, you will describe how to run your code and if your code depended on other packages. Finally, you will show and discuss the results of your algorithm. In the case of this project, show the results of matches and show the panoramas. Also, discuss anything extra you did. Feel free to add any other information you feel is relevant.

## Rubric
* +15 pts: Working implementation of matching SIFT 
* +15 pts: Working implementation of fitting the transformation matrix
* +20 pts: Working implementation of RANSAC
* +30 pts: Working implementation of stitching sequence of images
* +20 pts: Writeup with several examples of panorama
* +10 pts: Extra credit (up to ten points)
* -5*n pts: Lose 5 points for every time (after the first) you do not follow the instructions for the hand in format

## Get start & hand in
* Publicly fork version (+2 extra points)
	- [Fork the homework](https://education.github.com/guide/forks) to obtain a copy of the homework in your github account
	- [Clone the homework](http://gitref.org/creating/#clone) to your local space and work on the code locally
	- Commit and push your local code to your github repo
	- Once you are done, submit your homework by [creating a pull request](https://help.github.com/articles/creating-a-pull-request)

* [Privately duplicated version](https://help.github.com/articles/duplicating-a-repository)
  - Make a bare clone
  - mirror-push to new repo
  - [make new repo private](https://help.github.com/articles/making-a-private-repository-public)
  - [add aliensunmin as collaborator](https://help.github.com/articles/adding-collaborators-to-a-personal-repository)
  - [Clone the homework](http://gitref.org/creating/#clone) to your local space and work on the code locally
  - Commit and push your local code to your github repo
  - I will clone your repo after the due date

## Credits
	Assignment modified by Min Sun based on Fei-Fei Li and Ali Farhadi's previous developed projects
