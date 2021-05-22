# vhr-snow-mapper
produce validation grade 0.5m binary snow maps of viewable snow cover by pansharpening very high resolution 
(i.e. worldview 2/3) datasets and classifying semi-autonomously

please cite the following publicaiton if you use:

E. H. Bair, T. Stillinger and J. Dozier, "Snow Property Inversion From Remote Sensing (SPIReS): 
A Generalized Multispectral Unmixing Approach With Examples From MODIS and Landsat 8 OLI," 
in IEEE Transactions on Geoscience and Remote Sensing, doi: 10.1109/TGRS.2020.3040328.

This snow mapping algorithm was used in validation of SPIReS and is described in detail in section IV.A 

contact: Timbo Stillinger, PhD  tcs@ucsb.edu

If you want to use coarsenWV.m you will need the rasterReprojection repo: https://github.com/DozierJeff/RasterReprojection

Credits: 

mosaicTiles function is from Ned Bair (nbair@eri.ucsb.edu) 

pansharpening funcitons are from the pansharpening toolbox version 1.3: https://rscl-grss.org/coderecord.php?id=541
 G. Vivone, L. Alparone, J. Chanussot, M. Dalla Mura, A. Garzelli, G. Licciardi, R. Restaino, and L. Wald, 
 “A Critical Comparison Among Pansharpening Algorithms”, IEEE Transactions on Geoscience and Remote Sensing, 
 vol. 53, no. 5, pp. 2565-2586, May 2015
 
 
generates quite large files, recommened against parallel processing on small machines. 
