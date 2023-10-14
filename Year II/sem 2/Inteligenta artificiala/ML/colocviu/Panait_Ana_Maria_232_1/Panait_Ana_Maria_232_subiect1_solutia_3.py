import numpy as np

train_data = np.load("trainImages.npy")
train_labels = np.load("trainLabels.npy")

test_data = np.load("testImages.npy")


def binarizare_imagine(imag, T=0.5):
    imag_bin = np.array([0 if x < T else 1 for x in imag.flatten()])
    imag_bin = imag_bin.reshape(28, 28)
    return imag_bin


def patch_frequency(P=4):
    imag_binarizate = []
    for i in range(1200):
        imag_binarizate += binarizare_imagine(train_data[ :, : , i])
    