import numpy as np
from PIL import ImageFilter

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

def pred_test():
    med = imag_mediana()
    preds = [0 for _ in range(len(test_classes))]
    for idx, c in enumerate(test_classes):
        preds[idx] = med[c]
    
    with open("Panait_Ana_Maria_232_subiect1_solutia_1.csv", "w") as sc:
        sc.write("Target\n")
        for p in preds:
            sc.write(f"{p}\n")


pred_test()

