### special thanks to https://www.tensorflow.org/tutorials/keras/basic_classification ###
from __future__ import absolute_import, division, print_function

# TensorFlow and tf.keras
import tensorflow as tf
from tensorflow import keras

# Helper libraries
import cv2
import numpy as np
import matplotlib.pyplot as plt
import random
import helper # a bunch of helper functions
import os

def read_from_tfrecords(record_path):
	filenames = []
	for dir in os.listdir(record_path):
		file = os.listdir("{0}/{1}".format(record_path, dir))[0] # returns .tfrecord file; one per directory
		filenames.append("{0}/{1}/{2}".format(record_path, dir, file))
	labels_ = [i for i in range(0, len(os.listdir(record_path)))]
	labels_ = np.array(labels_)
	# print((filenames,labels))
	# quit()
	
	dataset = tf.data.TFRecordDataset(filenames)
	for i in range(0, 100): # shuffle 100 times
		dataset = dataset.shuffle(buffer_size=10000)  # 1000 should be enough right?
	for i in range(0, 100): # shuffle 100 times again
		dataset = dataset.shuffle(buffer_size=10000)  # 1000 should be enough right?
	
	feature_set = dataset.map(helper._parse_image_function)
	
	images = []
	labels = []
	print("Reading records...")
	counter = 0
	for features in feature_set:
		print("\r", end="")
		print(["   ", ".  ", ".. ", "..."][(int(counter / 1000) % 4)], end="")
		nparr = np.fromstring(features["image_raw"].numpy(),np.uint8)
		image = cv2.imdecode(nparr, cv2.IMREAD_GRAYSCALE)
		images.append(image)
		labels.append(features["label"].numpy())
		counter += 1
		# if counter > 5000:
			# break
	print("done")
	return images, labels
	
if __name__ == "__main__":
	print(tf.__version__)
	tf.enable_eager_execution()
	#test data for learning 
	 
	#fashion_mnist = keras.datasets.fashion_mnist

	#(train_images, train_labels), (test_images, test_labels) = fashion_mnist.load_data()

	#print(type(test_labels))

	#print(test_labels)

	#print(class_names)

	
	checkpoint_path = "model/cp.ckpt"
	cp_callback = tf.keras.callbacks.ModelCheckpoint(checkpoint_path,
													 save_weights_only = True,
													 verbose = 1)	
													 
	train_dir = "records/train"
	test_dir = "records/test"
	class_names = os.listdir(train_dir)
	
	# load all data
	print("Getting train data...")
	
	input_images, input_labels = ml.read_from_tfrecords(train_dir)
	
	print("Getting test data...")
	
	other_images, other_labels = ml.read_from_tfrecords(test_dir)
	
	#train data
	train_images = np.array(input_images) / 255.0
	train_labels = np.array(input_labels)
	
	#remove unwanted memory hogs
	del other_images
	del other_labels
	
	#validation data
	half = int(len(other_images) / 2)
	test_images = np.array(list(other_images[:half])) / 255.0
	test_labels = np.array(list(other_labels[:half]))
	#evaluation data
	eval_images = np.array(list(other_images[half:])) / 255.0
	eval_labels = np.array(list(other_labels[half:]))
	
	#remove unwanted memory hogs
	del input_images
	del input_labels

	#create logits
	# a = tf.Variable([100, 100], tf.float32)
	# b = tf.Variable([22,1], tf.float32)
	# mod_logits = tf.matmul(train_images, a) + b

	# model = helper.create_model(len(class_names), train_labels, mod_logits)
	model = helper.create_model(len(class_names))
	# COMMENCE TRAINING
	model.fit(train_images, train_labels, epochs=200,
			  validation_data = (test_images, test_labels),
			  callbacks = [cp_callback], shuffle=False)
	try:
		model.save_weights(checkpoint_path)
	except KeyboardInterrupt:
		print(e)
	
	print("Wrapping up training results...")

	test_loss, test_acc = model.evaluate(eval_images, eval_labels)
	
	
	print('Test accuracy: {0:.5f}'.format(test_acc*100))
	print('Test loss: {0:.5f}'.format(test_loss))

	predictions = model.predict(eval_images)

	print(len(predictions))


	# Plot the first X test images, their predicted label, and the true label
	# Color correct predictions in blue, incorrect predictions in red

	num_rows = 5
	num_cols = 3
	num_images = num_rows*num_cols
	plt.figure(figsize=(2*2*num_cols, 2*num_rows))
	for i in range(0,num_rows*num_cols):
		rand_num = random.randint(0,half)
		plt.subplot(num_rows, 2*num_cols, 2*i+1)
		helper.plot_image(class_names, rand_num, predictions, eval_labels, eval_images)
		plt.subplot(num_rows, 2*num_cols, 2*i+2)
		helper.plot_value_array(class_names, rand_num, predictions, eval_labels)

	plt.show()
	
	# # Initialize placeholders 

	# # Fully connected layer 
	# print(train_images[0].shape)
	# logits = tf.contrib.layers.fully_connected(train_images[0].shape, 62, tf.nn.relu)

	# # Define a loss function
	# loss = tf.reduce_mean(tf.nn.sparse_softmax_cross_entropy_with_logits(labels = [train_labels], 
																		# logits = logits))
	# # Define an optimizer 
	# train_op = tf.train.AdamOptimizer(learning_rate=0.001).minimize(loss)

	# # Convert logits to label indexes
	# correct_pred = tf.argmax(logits, 1)

	# # Define an accuracy metric
	# accuracy = tf.reduce_mean(tf.cast(correct_pred, tf.float32))
	
	# tf.set_random_seed(1234)

	# with tf.Session() as sess:
		# sess.run(tf.global_variables_initializer())
		# for i in range(201):
			# _, loss_value = sess.run([train_op, loss], feed_dict={x: train_images, y: train_labels})
			# if i % 10 == 0:
				# print("Loss: ", loss)
		# # Pick 10 random images
		# sample_indexes = random.sample(range(len(test_images)), 10)
		# sample_images = [test_images[i] for i in sample_indexes]
		# sample_labels = [test_labels[i] for i in sample_indexes]

		# # Run the "correct_pred" operation
		# predicted = sess.run([correct_pred], feed_dict={x: sample_images})[0]
								
		# # Print the real and predicted labels
		# print(sample_labels)
		# print(predicted)

		# # Display the predictions and the ground truth visually.
		# fig = plt.figure(figsize=(10, 10))
		# for i in range(len(sample_images)):
			# truth = sample_labels[i]
			# prediction = predicted[i]
			# plt.subplot(5, 2,1+i)
			# plt.axis('off')
			# color='green' if truth == prediction else 'red'
			# plt.text(40, 10, "Truth:        {0}\nPrediction: {1}".format(truth, prediction), 
					 # fontsize=12, color=color)
			# plt.imshow(sample_images[i],  cmap="gray")

		# plt.show()
	
	
	
