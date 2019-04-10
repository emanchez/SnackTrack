import os

dirs = os.listdir("Augmented_Test")

for dir in dirs:
	os.mkdir("records/train/{0}".format(dir))
	os.mkdir("records/test/{0}".format(dir))