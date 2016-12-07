# Ching-Yao Chuang 102061145

# Project 3 / Scene recognition with bag of words

## Overview
The project is related to 
> tiny image, nearest neighbor classifier, bags of SIFT features, 1-vs-all linear SVMS

## Implementation
###1. Tiny Image Representation
The "tiny image" feature is one of the simplest possible image representations. The only thing we need to do is simply resizing each image to a small, fixed resolution (16x16). 

In ```get_tiny_images.m```, I directly use ```imresize()``` and ```reshape()``` to aquire a 256D feature.

```python
image = imresize(imread(image_paths{i, 1}), [16 16]);
image_feat = reshape(image, [256, 1]);
```

Normalize the image feature will slightly increase the performance.

```python
image_feat = image_feat ./ sum(image_feat);   
image_feat = image_feat - mean(image_feat);    
```

###2. Nearest Neighbor Classifier
In NN Classifier, we simply finds the "nearest" training example and assigns the test case the label of that nearest training example.

<img src="img/nn.png" width="400"/>

In ```nearest_neighbor_classify.m``` we use ```vlfeat-0.9.20``` library to help us perform some complex steps.

```python
dist = vl_alldist2(train_image_feats', test_image_feats');
```

Here we predict category by finding the "nearest" training example.

```python
[junk, idx] = min(dist(i, :));
label = train_labels(idx, 1);
```

###3. Bags of SIFT
Here we are going to try another feature representation called bag of "visual" words. Visual words are ‘iconic’ image patches or fragments representing the frequency of word occurrence but not their position. In this project we use SIFT as our descriptors which indicate the distribution of the gradient over an image patch.

<img src="img/sift.png" width="600"/>

First, we establish a vocabulary of visual words by sampling many local features from our training set and then clustering them with kmeans (in ```build_volcabulary.m```).

Before clustering, we turn the image to gray scale.

```python
if size(image, 3) > 1
    image =rgb2gray(image);
end
```

Then use the library to acquire SIFT feature.
```python
[locat, SIFT_feat] = vl_dsift(image, 'step', 15, 'fast');
```

Now we can represent our training and testing images as histograms of visual words. For each image we will densely sample many SIFT descriptors. Instead of storing hundreds of SIFT descriptors, we simply count how many SIFT descriptors fall into each cluster in our visual word vocabulary. Here's the key part of code (skip rgb2gray & normalization).

```python
[locations, SIFT_feat] = vl_dsift(image, 'step', 3, 'fast');
[idx , dist] = vl_kdtreequery(forest , vocab' , double(SIFT_feat));
```

This part will take A LOT OF TIME. So I highly recommend that one can save the feature after running the function once.

```python
if split == 'train'
    save('train_feat.mat', 'image_feats');
else
    save('test_feat.mat', 'image_feats');
end
```

###4. 1-vs-all Linear SVMS
We train 1-vs-all linear SVMS to operate in the bag of SIFT feature space. Linear classifiers are one of the simplest possible learning models. The feature space is partitioned by a learned hyperplane and test cases are categorized based on which side of that hyperplane they fall on.

<img src="img/svm.png" width="300"/>

First we create binary labels for SVM training by using ```strcmp()```.

```python
matching_indices = strcmp(categories(i) , train_labels);
matching_indices = double(matching_indices);
for j = 1: size(train_labels, 1)
    if(matching_indices(j) == 0)
        matching_indices(j) = -1;
    end
end
```

Then we use the library to train a SVM classifier.

```python
[w, b] = vl_svmtrain(train_image_feats', matching_indices, lambda);
```

Note that we need to repeat the procedure above for each individual category.


## Installation
* Follow the [website](http://www.vlfeat.org/install-matlab.html) to setup VLFeat in MATLAB. 
* Simply run the code.

## Experiment Result

### Accuracy
<table border=0 cellpadding=4 cellspacing=1>
<tr>
<th>Method</th>
<th>Accuracy</th>
<th>Confusion Matrix</th>
</tr>
<tr>
<td>Random Guess</td>
<td>5.2%</td>
<td><img src="img/random.jpg" width="300"/></td>
</tr>
<td>Tiny Image + Nearest Neighbor (without normalize)</td>
<td>19.1%</td>
<td><img src="img/tiny_nn.jpg" width="300"/></td>
</tr>
</tr>
<td>Tiny Image + Nearest Neighbor (with normalize)</td>
<td>19.9%</td>
<td><img src="img/tiny_nn_norm.jpg" width="300"/></td>
</tr>
</tr>
<td>Bag of SIFT + Nearest Neigbor</td>
<td>49.8%</td>
<td><img src="img/sift_nn.jpg" width="300"/></td>
</tr>
</tr>
<td>Bag of SIFT + SVM (Lambda = 0.1)</td>
<td>40.6%</td>
<td><img src="img/sift_svm_1.jpg" width="300"/></td>
</tr>
</tr>
<td>Bag of SIFT + SVM (Lambda = 0.01)</td>
<td>46.3%</td>
<td><img src="img/sift_svm_2.jpg" width="300"/></td>
</tr>
</tr>
<td>Bag of SIFT + SVM (Lambda = 0.001)</td>
<td>61.3%</td>
<td><img src="img/sift_svm_3.jpg" width="300"/></td>
</tr>
</tr>
<td>Bag of SIFT + SVM (Lambda = 0.0001)</td>
<td>65.3%</td>
<td><img src="img/sift_svm_4.jpg" width="300"/></td>
</tr>
</tr>
<td>Bag of SIFT + SVM (Lambda = 0.00001)</td>
<td>62.7%</td>
<td><img src="img/sift_svm_5.jpg" width="300"/></td>
</tr>


<table border=0 cellpadding=4 cellspacing=1>
<tr>
<th>Category name</th>
<th>Accuracy</th>
<th colspan=2>Sample training images</th>
<th colspan=2>Sample true positives</th>
<th colspan=2>False positives with true label</th>
<th colspan=2>False negatives with wrong predicted label</th>
</tr>
<tr>
<td>Kitchen</td>
<td>0.520</td>
<td bgcolor=LightBlue><img src="thumbnails/Kitchen_image_0026.jpg" width=57 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Kitchen_image_0187.jpg" width=113 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Kitchen_image_0171.jpg" width=100 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Kitchen_image_0120.jpg" width=113 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/InsideCity_image_0041.jpg" width=75 height=75><br><small>InsideCity</small></td>
<td bgcolor=LightCoral><img src="thumbnails/LivingRoom_image_0020.jpg" width=113 height=75><br><small>LivingRoom</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Kitchen_image_0021.jpg" width=100 height=75><br><small>Bedroom</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Kitchen_image_0159.jpg" width=60 height=75><br><small>Office</small></td>
</tr>
<tr>
<td>Store</td>
<td>0.540</td>
<td bgcolor=LightBlue><img src="thumbnails/Store_image_0029.jpg" width=90 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Store_image_0310.jpg" width=100 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Store_image_0052.jpg" width=100 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Store_image_0031.jpg" width=109 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Industrial_image_0096.jpg" width=78 height=75><br><small>Industrial</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Industrial_image_0007.jpg" width=117 height=75><br><small>Industrial</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Store_image_0068.jpg" width=100 height=75><br><small>Highway</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Store_image_0087.jpg" width=107 height=75><br><small>TallBuilding</small></td>
</tr>
<tr>
<td>Bedroom</td>
<td>0.360</td>
<td bgcolor=LightBlue><img src="thumbnails/Bedroom_image_0133.jpg" width=113 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Bedroom_image_0078.jpg" width=87 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Bedroom_image_0007.jpg" width=101 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Bedroom_image_0098.jpg" width=91 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/LivingRoom_image_0135.jpg" width=116 height=75><br><small>LivingRoom</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Kitchen_image_0095.jpg" width=102 height=75><br><small>Kitchen</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Bedroom_image_0120.jpg" width=116 height=75><br><small>Store</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Bedroom_image_0122.jpg" width=101 height=75><br><small>LivingRoom</small></td>
</tr>
<tr>
<td>LivingRoom</td>
<td>0.350</td>
<td bgcolor=LightBlue><img src="thumbnails/LivingRoom_image_0184.jpg" width=114 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/LivingRoom_image_0170.jpg" width=113 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/LivingRoom_image_0005.jpg" width=93 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/LivingRoom_image_0146.jpg" width=114 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Bedroom_image_0150.jpg" width=100 height=75><br><small>Bedroom</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Bedroom_image_0029.jpg" width=133 height=75><br><small>Bedroom</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/LivingRoom_image_0073.jpg" width=100 height=75><br><small>Bedroom</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/LivingRoom_image_0136.jpg" width=100 height=75><br><small>Kitchen</small></td>
</tr>
<tr>
<td>Office</td>
<td>0.860</td>
<td bgcolor=LightBlue><img src="thumbnails/Office_image_0206.jpg" width=108 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Office_image_0036.jpg" width=113 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Office_image_0100.jpg" width=134 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Office_image_0112.jpg" width=123 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Bedroom_image_0093.jpg" width=101 height=75><br><small>Bedroom</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Bedroom_image_0056.jpg" width=113 height=75><br><small>Bedroom</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Office_image_0120.jpg" width=116 height=75><br><small>Kitchen</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Office_image_0150.jpg" width=92 height=75><br><small>Kitchen</small></td>
</tr>
<tr>
<td>Industrial</td>
<td>0.500</td>
<td bgcolor=LightBlue><img src="thumbnails/Industrial_image_0064.jpg" width=108 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Industrial_image_0048.jpg" width=41 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Industrial_image_0032.jpg" width=100 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Industrial_image_0005.jpg" width=114 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Store_image_0084.jpg" width=93 height=75><br><small>Store</small></td>
<td bgcolor=LightCoral><img src="thumbnails/InsideCity_image_0004.jpg" width=75 height=75><br><small>InsideCity</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Industrial_image_0114.jpg" width=49 height=75><br><small>TallBuilding</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Industrial_image_0046.jpg" width=57 height=75><br><small>Bedroom</small></td>
</tr>
<tr>
<td>Suburb</td>
<td>0.950</td>
<td bgcolor=LightBlue><img src="thumbnails/Suburb_image_0150.jpg" width=113 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Suburb_image_0115.jpg" width=113 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Suburb_image_0161.jpg" width=113 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Suburb_image_0140.jpg" width=113 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/InsideCity_image_0139.jpg" width=75 height=75><br><small>InsideCity</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Industrial_image_0068.jpg" width=94 height=75><br><small>Industrial</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Suburb_image_0053.jpg" width=113 height=75><br><small>Coast</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Suburb_image_0046.jpg" width=113 height=75><br><small>Mountain</small></td>
</tr>
<tr>
<td>InsideCity</td>
<td>0.490</td>
<td bgcolor=LightBlue><img src="thumbnails/InsideCity_image_0302.jpg" width=75 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/InsideCity_image_0255.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/InsideCity_image_0127.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/InsideCity_image_0040.jpg" width=75 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Street_image_0076.jpg" width=75 height=75><br><small>Street</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Street_image_0069.jpg" width=75 height=75><br><small>Street</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/InsideCity_image_0006.jpg" width=75 height=75><br><small>Store</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/InsideCity_image_0069.jpg" width=75 height=75><br><small>LivingRoom</small></td>
</tr>
<tr>
<td>TallBuilding</td>
<td>0.760</td>
<td bgcolor=LightBlue><img src="thumbnails/TallBuilding_image_0014.jpg" width=75 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/TallBuilding_image_0020.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/TallBuilding_image_0004.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/TallBuilding_image_0104.jpg" width=75 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Industrial_image_0030.jpg" width=113 height=75><br><small>Industrial</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Store_image_0087.jpg" width=107 height=75><br><small>Store</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/TallBuilding_image_0043.jpg" width=75 height=75><br><small>Mountain</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/TallBuilding_image_0064.jpg" width=75 height=75><br><small>Store</small></td>
</tr>
<tr>
<td>Street</td>
<td>0.700</td>
<td bgcolor=LightBlue><img src="thumbnails/Street_image_0039.jpg" width=75 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Street_image_0067.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Street_image_0083.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Street_image_0141.jpg" width=75 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Industrial_image_0138.jpg" width=100 height=75><br><small>Industrial</small></td>
<td bgcolor=LightCoral><img src="thumbnails/InsideCity_image_0137.jpg" width=75 height=75><br><small>InsideCity</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Street_image_0118.jpg" width=75 height=75><br><small>InsideCity</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Street_image_0052.jpg" width=75 height=75><br><small>Highway</small></td>
</tr>
<tr>
<td>Highway</td>
<td>0.790</td>
<td bgcolor=LightBlue><img src="thumbnails/Highway_image_0202.jpg" width=75 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Highway_image_0054.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Highway_image_0100.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Highway_image_0131.jpg" width=75 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Mountain_image_0082.jpg" width=75 height=75><br><small>Mountain</small></td>
<td bgcolor=LightCoral><img src="thumbnails/LivingRoom_image_0078.jpg" width=113 height=75><br><small>LivingRoom</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Highway_image_0001.jpg" width=75 height=75><br><small>Industrial</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Highway_image_0136.jpg" width=75 height=75><br><small>Coast</small></td>
</tr>
<tr>
<td>OpenCountry</td>
<td>0.440</td>
<td bgcolor=LightBlue><img src="thumbnails/OpenCountry_image_0247.jpg" width=75 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/OpenCountry_image_0390.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/OpenCountry_image_0051.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/OpenCountry_image_0005.jpg" width=75 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Suburb_image_0074.jpg" width=113 height=75><br><small>Suburb</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Mountain_image_0046.jpg" width=75 height=75><br><small>Mountain</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/OpenCountry_image_0057.jpg" width=75 height=75><br><small>Forest</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/OpenCountry_image_0114.jpg" width=75 height=75><br><small>Suburb</small></td>
</tr>
<tr>
<td>Coast</td>
<td>0.770</td>
<td bgcolor=LightBlue><img src="thumbnails/Coast_image_0250.jpg" width=75 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Coast_image_0345.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Coast_image_0087.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Coast_image_0002.jpg" width=75 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Highway_image_0022.jpg" width=75 height=75><br><small>Highway</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Mountain_image_0030.jpg" width=75 height=75><br><small>Mountain</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Coast_image_0005.jpg" width=75 height=75><br><small>Mountain</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Coast_image_0024.jpg" width=75 height=75><br><small>Suburb</small></td>
</tr>
<tr>
<td>Mountain</td>
<td>0.830</td>
<td bgcolor=LightBlue><img src="thumbnails/Mountain_image_0135.jpg" width=75 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Mountain_image_0323.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Mountain_image_0011.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Mountain_image_0083.jpg" width=75 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/Industrial_image_0091.jpg" width=57 height=75><br><small>Industrial</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Coast_image_0005.jpg" width=75 height=75><br><small>Coast</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Mountain_image_0046.jpg" width=75 height=75><br><small>OpenCountry</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Mountain_image_0081.jpg" width=75 height=75><br><small>OpenCountry</small></td>
</tr>
<tr>
<td>Forest</td>
<td>0.940</td>
<td bgcolor=LightBlue><img src="thumbnails/Forest_image_0240.jpg" width=75 height=75></td>
<td bgcolor=LightBlue><img src="thumbnails/Forest_image_0116.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Forest_image_0138.jpg" width=75 height=75></td>
<td bgcolor=LightGreen><img src="thumbnails/Forest_image_0041.jpg" width=75 height=75></td>
<td bgcolor=LightCoral><img src="thumbnails/OpenCountry_image_0046.jpg" width=75 height=75><br><small>OpenCountry</small></td>
<td bgcolor=LightCoral><img src="thumbnails/Store_image_0073.jpg" width=101 height=75><br><small>Store</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Forest_image_0117.jpg" width=75 height=75><br><small>Mountain</small></td>
<td bgcolor=#FFBB55><img src="thumbnails/Forest_image_0124.jpg" width=75 height=75><br><small>Mountain</small></td>
</tr>
<tr>
<th>Category name</th>
<th>Accuracy</th>
<th colspan=2>Sample training images</th>
<th colspan=2>Sample true positives</th>
<th colspan=2>False positives with true label</th>
<th colspan=2>False negatives with wrong predicted label</th>
</tr>
</table>
</center>


