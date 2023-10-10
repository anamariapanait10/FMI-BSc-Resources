import numpy as np
from sklearn.neighbors import KNeighborsClassifier

train_data = np.load("trainImages.npy")
train_classes = np.load("trainClasses.npy")
train_targets = np.load("trainTargets.npy")

test_data = np.load("testImages.npy")
test_classes = np.load("testClasses.npy")

def blureaza_poza(poza):
    poza_blurata = poza.filter(ImageFilter.GaussianBlur(radius=5))
    poza_blurata = np.array(poza_blurata.getdata())
    return poza_blurata

def imag_mediana():
    imag_med = [0 for _ in range(10)]
    for c in range(10):
        imags = [0 for _ in range(len(train_classes))]
        _len = 0
        for idx, et in enumerate(train_classes):
            if et == c:
                imags[_len] =  train_targets[:, :, idx]
                _len += 1
                break
        imags = imags[:_len]
        # imags = [blureaza_poza(img) for img in imags]
        imag_med = np.mean(imags, axis=0)
    return imag_med

knn = KNeighborsClassifier(n_neighbors=3, p=3)
knn.fit(train_data, train_targets)

img_pred = test_data[:, :, 0]
img_pred = test_data[:, :, 0] + np.array([0 for _ in range(2)]) + np.array[1] + np.array([0 for _ in range(25)])

knn.predict(img_pred)





