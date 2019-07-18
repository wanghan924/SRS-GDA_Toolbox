# SRS-GDA: A Spatial Random Sampling Toolbox for Grid-based Data Analysis

## Getting Started

SRS-GDA toolbox is motivated by and aimed at quantification on hydro-climatic responses driven by grid-based forcing datasets such as climate model projections, varying with locations and regions and scales. 

The toolbox can be used to grid map into different resolution(1km, 5km and 10km) and do random spatial sampling of grid-based quantities with various constraints: shape, size, location and dominant orientation.

More details can be found in the paper "SRS-GDA: A Spatial Random Sampling Toolbox for Grid-based Hydro-climatic Data Analysis in Environmental Change Studies" written by Han Wang and Yunqing Xuan

### Prerequisites and Introduction

The toolbox is developed on Matlab R2017a and can be used on Matlab R2017a or advanced version.

The toolbox must contain four main m files:

SRS_GDA_MapGeneration.m which is for grid-based map generation;
SRS_GDA_Location_Randomization.m which is for generating required samples at different locations in map;
SRS_GDA_Size_Randomization.m which is for generating required samples with different sizes in map;
SRS_GDA_Shape_Randomization.m which is for generating required samples with different shapes in map;

And 6 functions: Grid.m, Holes.m, Mapping.m, generatePolygon.m, generatePolygon2.m, Sample.m, Search.m;

And 4 other files: adjtable.txt (must have) and MapUK.txt, Original_UK_map_1km.mat and ExampleMap.jpg (these three for example demonstration)

### Running Steps and Instructions

Before sampling, grid-map generation is always the first step(SRS_GDA_MapGeneration.m) to go then you can use the rest three main files for your case study.

Here is instruction for the first step
```
Use the mat file of map (1km*1km):
step 1: run SRS_GDA_MapGeneration.m
step 2: choose the original map (example: type 2)
step 3: choose resolution (example: type 2)
step 4: if you want to save this map as txt file, type Yes, otherwise, press enter.

Use the jpg/png/tiff file of map (1km*1km):
step 1: run SRS_GDA_MapGeneration.m
step 2: choose the original map (example: type 1)
step 3: choose resolution (example: type 2 (we want resolution of 5km*5km))
step 4: choose ExampleMap.jpg
step 5: if you want to save this map as txt file, type Yes, otherwise, press enter.

Results: A grid-map figure and its grid information
```

Here is instruction for randomizing sample locations
```
step 1: run SRS_GDA_Location_Randomization.m
step 2: tell the resolution(1:1km 5:5km 10:10km) (example:5)
step 3*: type the number of samples (example: 5)
step 4*: type the size of those samples (example: 200)
step 5*: type the x index (example: press enter (we want to randomize it))
step 6*: type the y index (example: press enter (we want to randomize it))
step 7*: type the shape index sp(example: press enter (we want to randomize it))
Result: infor mat file which include the index of each sample.
Noted that step with * can be skipped by pressing Enter and toolbox will generate the value automatically.
```

Here is instruction for randomizing sample sizes
```
step 1: run SRS_GDA_Size_Randomization.m
step 2: tell the resolution(1:1km 5:5km 10:10km) (example:5)
step 3*: type the number of samples (example: 5)
step 4*: type an approximate size of those samples (example: 500)
step 5*: type the x index (example: press enter (we want to randomize it))
step 6*: type the y index (example: press enter (we want to randomize it))
step 7*: type the shape index sp(example: press enter (we want to randomize it))
Result: infor mat file which include the index of each sample.
Noted that step with * can be skipped by pressing Enter and toolbox will generate the value automatically.
```

Here is instruction for randomizing sample shapes
```
step 1: run SRS_GDA_Shape_Randomization.m
step 2: tell the resolution(1:1km 5:5km 10:10km) (example:5)
step 3*: type the number of samples (example: 5)
step 4*: type an approximate size of those samples (example: 500)
step 5*: type the x index (example: press enter (we want to randomize it))
step 6*: type the y index (example: press enter (we want to randomize it))
step 7: choose the sampling method
if you choose 1 which is shape-unconstrained sampling method then you do not need to define anything and just wait untill the results come out and the info mat would be saved authomatically.
if you choose 2 then follow: step 1*: type the shape index sp(example: press enter (we want to randomize it)).
                             step 2*: define how much variance there is in the angular spacing of vertices (example: press enter (we want to randomize it)).
							 step 3*: define how much variance there is in each vertex from the circle of radius (example: press enter (we want to randomize it)).
							 then waite for the results and they can be saved automatically as well.
Noted that step with * can be skipped by pressing Enter and toolbox will generate the value automatically.
```

## Contributing

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owner of this repository before making a change.

## Versioning

This is the orignal version which is labelled as Version 1.0. We keep improving the program.

## Author

* **Han Wang** - *Initial work* - [SRS-GDA_Toolbox](https://github.com/wanghan924/SRS-GDA_Toolbox.git)


## License

This project is licensed under the GNU GPL V3 License - see the [LICENSE.md](LICENSE.md) file for details

And this code supports the paper "SRS-GDA: A Spatial Random Sampling Toolbox for Grid-based Hydro-climatic Data Analysis in Environmental Change Studies" to be published and please also acknowledge this paper when you are applying this code in the future.

## Acknowledgments

1. The author would like to thank Mike Ounsworth whose code for polygon generation updated on StackOverflow contributed to this work.  

2. Thank the Centre of Hydrology and Ecology (CEH) for providing the GEAR dataset to test the toolbox. More details can be seen in "Tanguy, M., Dixon, H., Prosdocimi, I., Morris, D. G., & Keller, V. D. (2016). Gridded estimates of daily and monthly areal rainfall for the United Kingdom (1890-2009) [CEH-GEAR]. NERC Environmental Information Data Centre. Retrieved from NERC Environmental Information Data Centre: https://doi.org/10.5285/33604ea"

3. This study is supported by the Chinse Scholarship Council via its PhD scholarship offered to Han Wang and the Royal Academy of Engineering UK-China Urban Flooding Programme Grant (REF: UUFRIP\10021), which are both gratefully acknowledged.

4. Thank my supervisor Dr. Yunqing Xuan for the help and paper contribution.
