### special thanks to https://www.tensorflow.org/tutorials/ ###
from __future__ import absolute_import, division, print_function

# TensorFlow and tf.keras
import tensorflow as tf
from tensorflow import keras

# Helper libraries
import numpy as np
import matplotlib.pyplot as plt
import os
import random
import helper
from PIL import Image
import ml

def predict(imgpath, model_path="model/model_v5.h5"):
	print("Reloading model...")
	checkpoint_path = "model/cp.ckpt"
	#cp_callback = tf.keras.callbacks.ModelCheckpoint(checkpoint_path,
	#												 save_weights_only = True,
	#												 verbose = 1)	
	class_names = []
	with open("misc/list_of_fruits.txt", "r") as f:
		class_names = f.readlines()
		
	
	
	model = keras.models.load_model(model_path)
	
	model.compile(optimizer=tf.train.AdamOptimizer(learning_rate=0.001), 
				  loss='sparse_categorical_crossentropy',
				  metrics=['accuracy'])
				  
	model.load_weights(checkpoint_path)
	
	img = Image.open(imgpath).convert("L")
	scaled_img = img.resize((100,100))

	# out_shape = tf.convert_to_tensor([100, 100])
	# image = tf.image.decode_jpeg(tf.read_file(imgpath))

	# # some mapping to constant size - be careful with distorting aspec ratios
	# image = tf.image.resize_images(image, out_shape)
	# image = tf.image.rgb_to_grayscale(image)
	# # color normalization - just an example
	# image = tf.to_float(image) * (2. / 255) - 1
	a = np.array(scaled_img, dtype=np.uint8) / 255.0
	with open("ErrorLog.txt", "w") as f:
		f.write("Image shape: {}\n".format(a.shape))

	predictions = model.predict_classes(np.array(a).reshape(1,100,100))
	
	with open("misc/result.txt", "w") as f:
		for i in predictions:
			f.write("Found prediction: label=%s name=%s" % (i, class_names[i]))
	tf.keras.backend.clear_session()
	
if __name__ == "__main__":
	train_dir = "records/train"
	test_dir = "records/test"
	tf.enable_eager_execution()
	
	class_names = os.listdir(train_dir)
	model = helper.create_model(len(class_names))
	
	# load all data
	print("Getting train data...")
	
	input_images, input_labels = ml.read_from_tfrecords(train_dir)
	
	print("Getting test data...")
	
	other_images, other_labels = ml.read_from_tfrecords(test_dir)
	
	#train data
	train_images = np.array(input_images) / 255.0
	train_labels = np.array(input_labels)
	
	#remove unwanted memory hogs
	del input_images
	del input_labels	
	
	#validation data
	half = int(len(other_images) / 2)
	test_images = np.array(list(other_images[:half])) / 255.0
	test_labels = np.array(list(other_labels[:half]))
	#evaluation data
	eval_images = np.array(list(other_images[half:])) / 255.0
	eval_labels = np.array(list(other_labels[half:]))
	
	#remove unwanted memory hogs
	del other_images
	del other_labels

	
	print(str((len(test_images),len(eval_images))))
	# input()
	# reload model
	print("Reloading model...")
	checkpoint_path = "model/cp.ckpt"
	cp_callback = tf.keras.callbacks.ModelCheckpoint(checkpoint_path,
													 save_weights_only = True,
													 verbose = 1)	
	model.load_weights(checkpoint_path)
	#retrain model
	
	print("Begin")
	try:
		model.fit(train_images, train_labels, epochs=200, batch_size=64,
			  validation_data = (test_images, test_labels),
			  callbacks = [cp_callback], shuffle=False)
	except KeyboardInterrupt as e:
		print(e)

	
	
	loss, acc = model.evaluate(eval_images, eval_labels)
	print("Restored model: {0:.5f}% accuracy".format(acc*100))
	print("Restored model: {0:.5f} loss".format(loss))
	
	model.save("model/model_v5.h5")
	
	predictions = model.predict(eval_images)
	
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