### special thanks to https://www.tensorflow.org/tutorials/keras/basic_classification ###
from __future__ import absolute_import, division, print_function

# TensorFlow and tf.keras
import tensorflow as tf
from tensorflow import keras

# Helper libraries
import numpy as np
import matplotlib.pyplot as plt
import random
import helper # a bunch of helper functions
import os

# Threading!
import threading

		
def task1(src_dir, dst_dir, arr, file_counter):
	for name in arr:
		write_to_tfrecord(src_dir, dst_dir, name, file_counter)

def task2(file_counter, msg):
	while file_counter.counter < file_counter.quantity:
		helper.print_progress(file_counter.counter, file_counter.quantity, msg, 50)

def write_to_tfrecord(src_dir, dst_dir, name, file_counter):
	images = []
	labels = []
	temp_images, temp_labels = helper.make_array(name, src_dir, show_progress=False)
	for i in range(0, len(temp_images)):
		images.append(temp_images[i])
		images.append(temp_labels[i])
			
	temp_images = np.array(temp_images)
	temp_labels = np.array(temp_labels)
	
	with tf.python_io.TFRecordWriter('{0}/{1}/{1}.tfrecords'.format(dst_dir, name)) as writer:
	
		for i in range(0, len(list(temp_images))):
			try:
				tf_example = helper.image_example(temp_images[i], temp_labels[i])
			except TypeError as e:
				print(e)
				print(train_labels[i-2])
				quit()
			writer.write(tf_example.SerializeToString())	
			file_counter.counter += 1
			
	
if __name__ == "__main__":

	train_dir = "Augmented_Train"
	test_dir = "Augmented_Test"
	record_dir = "records"
	class_names = os.listdir(train_dir)
	# split indices -> 0, 7, 14, 22
	# first thread will process [0, 7)
	# second thread will process [7, 14)
	# third thread will process [14, 22)
	# fourth thread will report the progresss
	
	# TRAINING IMAGES
	dst = "{0}/train".format(record_dir)
	file_counter = helper.Quantifier(train_dir)
	
	t1 = threading.Thread(target=task1, args=(train_dir, dst, class_names[0:7], file_counter,))
	t2 = threading.Thread(target=task1, args=(train_dir, dst, class_names[7:14], file_counter,))
	t3 = threading.Thread(target=task1, args=(train_dir, dst, class_names[14:len(class_names)], file_counter,))
	t4 = threading.Thread(target=task2, args=(file_counter,"Writing training records... ",))
	
	try:
		t1.start()
		t2.start()
		t3.start()
		t4.start()
		
		t1.join()
		t2.join()
		t3.join()
		t4.join()
	except KeyboardInterrupt as e:
		print(e)
		quit()
		
	# TEST IMAGES
	dst = "{0}/test".format(record_dir)
	file_counter = helper.Quantifier(test_dir)
	
	t1 = threading.Thread(target=task1, args=(test_dir, dst, class_names[0:7], file_counter,))
	t2 = threading.Thread(target=task1, args=(test_dir, dst, class_names[7:14], file_counter,))
	t3 = threading.Thread(target=task1, args=(test_dir, dst, class_names[14:len(class_names)], file_counter,))
	t4 = threading.Thread(target=task2, args=(file_counter,"Writing testing records... ",))
	
	try:
		t1.start()
		t2.start()
		t3.start()
		t4.start()
		
		t1.join()
		t2.join()
		t3.join()
		t4.join()
	except KeyboardInterrupt as e:
		print(e)
		quit()
	
	# train_images = []
	# train_labels = []
	# for name in class_names: # build train file
		# write_to_tfrecord(train_dir, "{0}/train".format(record_dir), name)
	
		# temp_train, temp_labels = helper.make_array(name, train_dir)
		# for i in range(0, len(temp_train)):
			# train_images.append(temp_train[i])
			# train_labels.append(temp_labels[i])
	

	
	# train_images = np.array(train_images)
	# train_labels = np.array(train_labels)
		
	# with tf.python_io.TFRecordWriter('records/train_images.tfrecords') as writer:
	
		# for i in range(0, len(list(train_images))):
			# helper.print_progress(i, len(list(train_images)), "Recording Train {0} ".format(["-","/","|","\\"][i % 4]), 50)
			# try:
				# tf_example = helper.image_example(train_images[i], train_labels[i])
			# except TypeError:
				# print(train_labels[i-2])
				# quit()
			# writer.write(tf_example.SerializeToString())	
			
	# print()
	
	# del train_images
	# del train_labels
	
	# test_images = []
	# test_labels = []
	# for name in class_names: # build test file
		# write_to_tfrecord(test_dir, "{0}/test".format(record_dir), name)
		
		# temp_test, temp_labels = helper.make_array(name, test_dir)
		# for i in range(0, len(temp_test)):
			# test_images.append(temp_test[i])
			# test_labels.append(temp_labels[i])

	# test_images = np.array(test_images)
	# test_labels = np.array(test_labels)
		
	# with tf.python_io.TFRecordWriter('records/test_images.tfrecords') as writer:
	
	
		# for i in range(0, len(list(test_images))):
			# helper.print_progress(i, len(list(test_images)), "Recording Test {0} ".format(["-","/","|","\\"][i % 4]), 50)
			# tf_example = helper.image_example(test_images[i], test_labels[i])
			# writer.write(tf_example.SerializeToString())
	
	# print()
	# del test_images
	# del test_labels