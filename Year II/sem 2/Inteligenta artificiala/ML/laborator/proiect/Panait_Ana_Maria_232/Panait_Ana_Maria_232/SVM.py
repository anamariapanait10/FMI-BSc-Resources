# Modelul masini cu vectori suport
import csv
import numpy as num
from PIL import Image, ImageFilter
from cv2 import imread
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, confusion_matrix, f1_score, precision_score, recall_score


prefix_directoare = "./proiect/unibuc-dhc-2023"  # prefixul comun al cailor folosite
augmentare_si_procesare_date = False  # variabila folosita pt a putea seta daca folosim augmentari/procesari sau nu


def normalizeaza_standard(poze):
    # folosesc normalizarea standard pe toate pozele
    return StandardScaler().fit_transform(poze)

def blureaza_poza(poza):
    poza_blurata = Image.open(f"{prefix_directoare}/train_images/{poza}") # citim inca o data imaginea
    poza_blurata = poza_blurata.filter(ImageFilter.GaussianBlur(radius=5)) # aplicam blur
    poza_blurata = num.array(poza_blurata.getdata()).flatten() # transformam in array si apoi reducem dimensiunea
    return poza_blurata

def roteste_imaginea(poza):
    poza_rotita = Image.open(f"{prefix_directoare}/train_images/{poza}") # citim inca o data imaginea
    poza_rotita = poza_rotita.rotate(90) # rotim imaginea
    poza_rotita = num.array(poza_rotita.getdata()).flatten() # transformam in array si apoi reducem dimensiunea
    return poza_rotita
    
def calculeaza_ponderile_claselor(ant_etichs):
    nr_cls = len(ant_etichs)
    # calculam ponderile claselor ca complementul fata de 1 
    # a numarului de etichete de acel tip pe nr toatal de etichete
    ponderile_claselor = [1 - ant_etichs.count(str(e)) / nr_cls for e in range(nr_cls)]
    # dupa transform lista in dictionar
    ponderile_claselor_dict = {}
    for e in range(nr_cls):
        ponderile_claselor_dict[str(e)] = ponderile_claselor[e]
    return ponderile_claselor_dict


tr_imgs = []
tr_etichs = []
val_imgs = []
val_etichs = []
test_imgs = []
test_nume_imgs = []
print("Incepe citirea")
for tr_val in ["train", "val", "test"]:  # citim pe rand datele de train, validare si testare
    with open(f"{prefix_directoare}/{tr_val}.csv") as inp:
        inp = csv.reader(inp, delimiter=",")
        next(inp)  # sarim peste prima linie cu numele coloanelor
        for _inp in inp:
            # citim imaginile, le transformam din matrice in vector si le retinem in liste;
            # pastram si etichetele ca siruri de caractere in liste
            if tr_val == "train":
                imag, etch = _inp
                tr_imgs.append(num.array(Image.open(f"{prefix_directoare}/{tr_val}_images/{imag}").getdata()).flatten())
                tr_etichs.append(etch)
                if augmentare_si_procesare_date:
                    # adaug imaginea citita anterior dar blurata, cu acelasi label
                    tr_imgs.append(blureaza_poza(imag))
                    tr_etichs.append(etch)
                    # augmentez imaginea rotita cu 90 de grade, cu acelasi label
                    tr_imgs.append(roteste_imaginea(imag))
                    tr_etichs.append(etch)
            elif tr_val == "val":
                imag, etch = _inp
                val_imgs.append(imread(f"{prefix_directoare}/{tr_val}_images/{imag}").flatten())
                val_etichs.append(etch)
            else:
                imag = _inp[0]
                # retinem si numele imaginilor ca sa le afisam in csvul cu predictiile datelor de test
                test_nume_imgs.append(imag)
                test_imgs.append(imread(f"{prefix_directoare}/{tr_val}_images/{imag}").flatten())

print("Incepe normalizarea")
# normalizam datele
# tr_imgs = normalizeaza_standard(tr_imgs)
# val_imgs = normalizeaza_standard(val_imgs)
# test_imgs = normalizeaza_standard(test_imgs)

# tinem cont de distributia neuniforma a claselor calculand o pondere
# a importantei pentru fiecare
ponderi = calculeaza_ponderile_claselor(tr_etichs)

# hiperparametrii
_k = "rbf"
_C = 0.1
_gamma = "scale"

print("Incepe antrenarea")
_svm_model = SVC(kernel=_k, class_weight=ponderi, C=_C, gamma=_gamma)
_svm_model.fit(tr_imgs, tr_etichs) # antrenam modelul pe datele de train
svm_val_preds = _svm_model.predict(val_imgs) # facem predictiile pe datele de validare

# afisam statisticile pe baza predictiilor
print(f"Modelul SVM cu kernelul {_k}, C = {_C}, gamma = {_gamma} are acuratetea egala cu {accuracy_score(val_etichs, svm_val_preds)},", end=" ")
print(f"precizia {precision_score(val_etichs, svm_val_preds, average=None)}, recallul {recall_score(val_etichs, svm_val_preds, average=None)},", end=" ")
print(f"f1 score {f1_score(val_etichs, svm_val_preds, average=None)} si matricea de confuzie: {confusion_matrix(val_etichs, svm_val_preds)}")


# facem predictiile pe datele de test si le afisam intr un csv
svm_test_preds = _svm_model.predict(test_imgs)
with open("predictii_svm.csv", "w") as sc:
    sc.write("Image,Class\n")
    for i in range(len(svm_test_preds)):
        sc.write(f"{test_nume_imgs[i]},{svm_test_preds[i]}\n")