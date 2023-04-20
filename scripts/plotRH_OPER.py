from netCDF4 import Dataset
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.colors as colors
from matplotlib.cm import get_cmap
import cartopy
import cartopy.crs as crs
from cartopy.feature import NaturalEarthFeature
from wrf import (to_np, getvar, smooth2d, get_cartopy, cartopy_xlim, cartopy_ylim, latlon_coords, ALL_TIMES)
import numpy
import os
import sys
import pandas
import cartopy.io.shapereader as shpreader
import cartopy.feature as cfeature


def plot(fileInput, out_folder):
	fileInput = Dataset(fileInput)
	var = "rh"
	times = getvar(fileInput, "Times")
	get_var = getvar(fileInput, var)
	get_var = get_var[0]
	lats, lons = latlon_coords(get_var)
	cart_proj = get_cartopy(get_var)	
	
	cmap=plt.get_cmap('Blues')
	norm = mpl.colors.Normalize(vmin=0, vmax=100)
	
	fig = plt.figure(figsize=(12, 9), dpi=100)
	ax = fig.add_subplot(projection=cart_proj)
	get_var_np = to_np(get_var)
	ax.set_xlim(cartopy_xlim(get_var))
	ax.set_ylim(cartopy_ylim(get_var))
	cmsh = ax.pcolormesh(to_np(lons), to_np(lats), get_var_np, cmap=cmap, zorder=1, transform=crs.PlateCarree())
	
	ax.add_feature(cfeature.BORDERS)
	ax.add_feature(cfeature.COASTLINE, zorder=3)
	
	fname = '/home/afalcione/OPER/plots/shapefiles/gadm41_ITA_1.shp'
	adm1_shapes = list(shpreader.Reader(fname).geometries())
	ax.add_geometries(adm1_shapes, crs.PlateCarree(), edgecolor='black', facecolor='none', alpha=0.35, zorder=2) #faceocolor era "gray"

	plt.title("Umidità relativa " + str(pandas.to_datetime(to_np(times))))
	
	cbar = fig.colorbar(mpl.cm.ScalarMappable(cmap=cmap, norm=norm))
	cbar.set_label("%", rotation=0)
	plt.savefig(out_folder + '.jpg', bbox_inches='tight')

files = sys.argv[1]
output_folder = sys.argv[2] if len(sys.argv)> 2 else 'D:\Model/'

	
plot(files, output_folder)
