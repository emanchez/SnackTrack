### special thanks to https://www.tensorflow.org/tutorials/keras/basic_classification ###
from __future__ import absolute_import, division, print_function

# TensorFlow and tf.keras
import tensorflow as tf
from tensorflow import keras

# Helper libraries
import numpy as np
import matplotlib.pyplot as plt
import cv2
import os
import random
import time

		
# The following functions can be used to convert a value to a type compatible
# with tf.Example.
# THANKS https://www.tensorflow.org/tutorials/load_data/tf_records

def _bytes_feature(value):
	"""Returns a bytes_list from a string / byte."""
	return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value]))

def _float_feature(value):
	"""Returns a float_list from a float / double."""
	return tf.train.Feature(float_list=tf.train.FloatList(value=[value]))

def _int64_feature(value):
	"""Returns an int64_list from a bool / enum / int / uint."""
	return tf.train.Feature(int64_list=tf.train.Int64List(value=[value]))
	
def _parse_image_function(example_proto):
	# Create a dictionary describing the features.  
	image_feature_description = {
		'height': tf.FixedLenFeature([], tf.int64),
		'width': tf.FixedLenFeature([], tf.int64),
		'depth': tf.FixedLenFeature([], tf.int64),
		'label': tf.FixedLenFeature([], tf.int64),
		'image_raw': tf.FixedLenFeature([], tf.string),
	}
	
	# Parse the input tf.Example proto using the dictionary above.
	return tf.parse_single_example(example_proto, image_feature_description)
  
def image_example(img, label):

	feature = {
	  'height': _int64_feature(img.shape[0]),
	  'width': _int64_feature(img.shape[1]),
	  'depth': _int64_feature(img.shape[2]),
	  'label': _int64_feature(label),
	  'image_raw': _bytes_feature(cv2.imencode(".jpg", img)[1].tobytes())
	}
	
	return tf.train.Example(features=tf.train.Features(feature=feature))

class Quantifier: # this is to help with print progress function for multithreading; it acquires the total size of the number of
	def __init__(self, dir, nested=True):
		count = 0
		if nested:
			for sub_dir in os.listdir(dir):
				count += len(os.listdir("{0}/{1}".format(dir, sub_dir)))
		else:
			count += os.listdir(dir)
		self.quantity = count
		self.counter = 0

def print_progress(idx, size, lead_msg="", bar_length=10):
	animated_object = ["-", "/", "|", "\\"]
	curr_frame = animated_object[int(time.time()) % len(animated_object)]
	#print the length/current index as a progress bar
	#it will look something like this:
	#	[======----] 60%
	idx=idx+1 # to ensure that the bar reaches 100%, doesnt have to be super accurate
	progress = idx / size # current progress in decimal format
	print('\r' + lead_msg, end='') # print the cursor-return and the pre-defined leading string (such as 'loading' or tab)
	
	# calculate the progress bar appearance using string arithmetic
	visual_progress = int(progress * bar_length) # percantage of length of bar; truncate decimal
	visual_remainder = bar_length - visual_progress # 1 - percentage of length of bar; truncate decimal
	print("[{0}{1}] {2}%\t{3}".format("="*visual_progress, "-"*visual_remainder, int(progress * 100), curr_frame), end="")
	
def create_model(num_classes):
	model = keras.Sequential([
		keras.layers.Flatten(input_shape=(100, 100)),
		keras.layers.Dense(128, activation=tf.nn.relu),
		keras.layers.Dense(num_classes, activation=tf.nn.softmax)
	])

	model.compile(optimizer=tf.train.AdamOptimizer(learning_rate=0.001), 
				  loss='sparse_categorical_crossentropy',
				  metrics=['accuracy'])
	return model
	
def plot_image(class_names, i, predictions_array, true_label, img):
	predictions_array, true_label, img = predictions_array[i], true_label[i], img[i]
	plt.grid(False)
	plt.xticks([])
	plt.yticks([])

	plt.imshow(img, cmap=plt.cm.binary)

	predicted_label = np.argmax(predictions_array)
	if predicted_label == true_label:
		color = 'blue'
	else:
		color = 'red'

	plt.xlabel("{} {:2.0f}% ({})".format(class_names[predicted_label],
								100*np.max(predictions_array),
								class_names[true_label]),
								color=color)

def plot_value_array(class_names, i, predictions_array, true_label):
	predictions_array = predictions_array[i]
	true_label = true_label[i]
	plt.grid(False)
	plt.xticks([])
	plt.yticks([])
	thisplot = plt.bar(range(len(class_names)), predictions_array, color="#777777")
	plt.ylim([0, 1]) 
	predicted_label = np.argmax(predictions_array)

	thisplot[predicted_label].set_color('red')
	thisplot[true_label].set_color('blue')


def load_image( infilename ) : # load image as a numpy array (COPY/PASTE, MUST CHANGE)
	img = cv2.imread(infilename) # load the image and convert it to grayscale (with .convert("L"))
	
	#preprocess
	return img

def make_array(name, src_dir, show_progress = True):
	#WARNING: you must have images stored in nested directories, and the parent directories must exist in the same directory
	#example:
	#	this_script.py
	#	directory1
	#		directory1.1
	#			image(s).jpg
	#			...
	#	directory2
	#		directory2.1
	#			image(s).jpg
	#			...
	#	somefile.exe

	image_array = [] # array to store the images
	label_array = [] # we only have: [apple, banana, orange, strawberry, avocado]
	
	count = 0 # variable to track number of images DEBUG
	print("Directory: " + name)
	images = os.listdir("{0}/{1}".format(src_dir, name))
	cap = max([100,len(images)]) # debug
	for i in range (0, cap): # list of images for each image
	
		try: # catch errors
			count += 1 # count total number of images DEBUG
			# convert jpg to numpy arrays
			if show_progress:
				print_progress(i, cap, "\t\t", 20) # print progress for the aesthetic
			label_array.append(os.listdir(src_dir).index(name)) # append name of class (retrieved from list of directories in the src_dir directory) to label array
			image_array.append(load_image("{0}/{1}/{2}".format(src_dir, name, images[i]))) # append image to numpy array
			#### both of these arrays are set up in a way where the index of a label will match the index of an image
				
				
		except NotADirectoryError:
			continue # ignore anything that is not a directory
	
	print() # print newline for console output format DEBUG
	print("total images: " + str(count)) # print the total number of images at the end of the loading stage
	
	return image_array, label_array # return both the numpy array and the label array

	
####USELESS####
# def	train(train_dir, test_images, test_labels,
			# name, name_index, 
			# model, checkpoint_path, cp_callback, epochs_ = 2):
			
		# train_images, train_labels = make_array(name, train_dir) #make sure that the folders exist in the same directory
		
		# #convert python lists to numpy arrays
		# train_images = np.array(train_images)
		# train_labels = np.array(train_labels)
		
		# test_images = np.array(test_images)
		# test_labels = np.array(test_labels)

		# # must do this for preprocessing according to the internet
		
		# train_images = train_images / 255.0 
		# test_images = test_images / 255.0
		
		# # COMMENCE TRAINING

				  
		# model.fit(train_images, train_labels, epochs=epochs_,
				  # validation_data = (test_images, test_labels), 
				  # callbacks = [cp_callback])

		# model.save_weights(checkpoint_path)
		
		# return model