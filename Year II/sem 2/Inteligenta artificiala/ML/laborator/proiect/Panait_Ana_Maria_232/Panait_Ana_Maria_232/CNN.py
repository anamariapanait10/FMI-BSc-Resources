# Modelul CNN
import csv
import os
import pandas as pand
import statistics
import torch
import torch.nn as net
import torch.optim as opti
import torchvision.transforms as trsf
from PIL import Image as I
from torch.utils.data import DataLoader, Dataset


prefix_directoare = "./proiect/unibuc-dhc-2023" # prefixul comun al cailor folosite

# hiperparametrii
nr_de_epoci = 200
rata_de_invatare = 0.0003
degradarea_ratei_de_invatare = 0.00001
dim_batch = 32


class SetDeDatePersonalizat(Dataset):
    # clasa folosita pentru incarcarea si prelucrarea seturilor de date
    def __init__(self, dir_imagini, etichs, transform=None):
        self.dir_imagini = dir_imagini
        self.etichs = pand.read_csv(etichs)
        self.transform = transform

    def __getitem__(self, index):
        # returnează perechea (imagine, eticheta) corespunzătoare unui anumit index 
        # din setul de date
        imagine = I.open(os.path.join(self.dir_imagini, self.etichs.iloc[index, 0]))
        if self.transform is not None:
            imagine = self.transform(imagine)
            
        if "test" not in self.dir_imagini:
            label = self.etichs.iloc[index, 1]
            return (imagine, label)
        
        return imagine      

    def __len__(self):
        return len(self.etichs)  


tr_set = SetDeDatePersonalizat(
    f"{prefix_directoare}/train_images", 
    f"{prefix_directoare}/train.csv", 
    transform=trsf.Compose([
        trsf.RandomApply([trsf.GaussianBlur(kernel_size=3)], p=0.5),
        trsf.ToTensor(),
    ])
)

tr_loader = DataLoader(
    dataset=tr_set,
    batch_size=dim_batch,
    shuffle=True,
)


val_set = SetDeDatePersonalizat(
    f"{prefix_directoare}/val_images", 
    f"{prefix_directoare}/val.csv", 
    transform=trsf.Compose([
        trsf.ToTensor(),
    ])
)

val_loader = DataLoader(
    dataset=val_set,
    batch_size=dim_batch,
    shuffle=False,
)


test_set = SetDeDatePersonalizat(
    f"{prefix_directoare}/test_images", 
    f"{prefix_directoare}/test.csv", 
    transform=trsf.Compose([
        trsf.ToTensor(),
    ])
)

test_loader = DataLoader(
    dataset=test_set,
    batch_size=dim_batch,
    shuffle=False,
)


def calculeaza_ponderile_claselor():
    ant_etichs = []
    with open(f"{prefix_directoare}/train.csv") as inp:
        _inp = csv.reader(inp)
        next(_inp)
        for _lin in _inp:
            ant_etichs.append(_lin[1])

    # calculam ponderile claselor ca complementul fata de 1 
    # a numarului de etichete de acel tip pe nr toatal de etichete
    ponderile_claselor = [1 - ant_etichs.count(str(e)) / 96 for e in range(96)]
    return torch.tensor(ponderile_claselor, dtype=torch.float)


class ClasaUtila(net.Module):
    
    def __init__(self):
        super().__init__()
        neuroni_strat_1 = 32
        neuroni_strat_2 = 64
        neuroni_strat_3 = 128
        neuroni_strat_4 = 256
        numar_clase = 96
        _pool_s = 2
        _pool_k = 2
        _k = 3
        _pool_p = 0
        _p = 1
        _s = 1
        self.img_model = net.Sequential(
            net.Conv2d(in_channels=3, out_channels=neuroni_strat_1, kernel_size=_k, stride=_s, padding=_p, bias=False),
            net.MaxPool2d(kernel_size=_pool_k, stride=_pool_s, padding=_pool_p),
            net.BatchNorm2d(neuroni_strat_1),
            net.ReLU(inplace=True),

            net.Conv2d(in_channels=neuroni_strat_1, out_channels=neuroni_strat_2, kernel_size=_k, stride=_s, padding=_p, bias=False),
            net.MaxPool2d(kernel_size=_pool_k, stride=_pool_s, padding=_pool_p),
            net.BatchNorm2d(neuroni_strat_2),
            net.ReLU(inplace=True),

            net.Conv2d(in_channels=neuroni_strat_2, out_channels=neuroni_strat_3, kernel_size=_k, stride=_s, padding=_p, bias=False),
            net.MaxPool2d(kernel_size=_pool_k, stride=_pool_s, padding=_pool_p),
            net.BatchNorm2d(neuroni_strat_3),
            net.ReLU(inplace=True),

            net.Conv2d(in_channels=neuroni_strat_3, out_channels=neuroni_strat_4, kernel_size=_k, stride=_s, padding=_p, bias=False),
            net.MaxPool2d(kernel_size=_pool_k, stride=_pool_s, padding=_pool_p),
            net.BatchNorm2d(neuroni_strat_4),
            net.ReLU(inplace=True),

            net.Flatten(),
            net.Linear(in_features=16 * neuroni_strat_4, out_features=numar_clase, bias=True),
        )

    def forward(self, _input):
        return self.img_model(_input)

lossuri_validare = []
acuratete_validare = []
def evalueaza(model, eval_set):
    model.eval() # setam modelul in modul de evaluare
    lossuri = []
    total = 0
    acuratete = 0
    with torch.no_grad():
        for imagini, labeluri in eval_set:
            predictii = model(imagini) # facem predictii pe setul de validare

            loss = crit(predictii, labeluri)
            lossuri.append(loss.item())

            # calculam acuratețea prin compararea clasele prezise cu clasele adevaratele
            acuratete += sum((torch.argmax(predictii, 1) == labeluri).float())
            total += len(predictii)

    acuratete = acuratete / total
    lossuri_validare.append(statistics.mean(lossuri))
    acuratete_validare.append(acuratete)
    return statistics.mean(lossuri), acuratete


lossuri_antrenare = []
acuratete_antrenare = []
nr_epoci_adevarat = nr_de_epoci
def antreneaza(model, opt):
    contor_oprire_prematura = 0
    cel_mai_bun_loss = 1000000000000000
    acc_antr = 0
    for epoca in range(nr_de_epoci):
        lossuri = [] # retin lossul pt fiecare epoca pt plotarea graficului
        for imagini, labeluri in tr_loader:
            model.train() # setam modelul in modul de antrenare
            predictii = model(imagini) # predictiile pt batchul curent
            loss = crit(predictii, labeluri)
            # calculam regularizarea l2 si o adaugam la pierderea calculata anterior
            l2_lambda = 0.001
            l2_norm = sum(p.pow(2.0).sum() for p in model.parameters())
            loss = loss + l2_lambda * l2_norm
            
            lossuri.append(loss.item())
            # calculam acuratetea predictilor in raport cu clasele reale
            acc_antr += sum((torch.argmax(predictii, 1) == labeluri).float()) / len(tr_loader)
            
            opt.zero_grad() # resetam gradientii
            loss.backward() # actualizam parametrii modelului
            opt.step()

        # calculam media pierderilor din cadrul epocii
        lossuri_antrenare.append(statistics.mean(lossuri))
        # evaluam modelul pe setul de validare
        val_loss, valid_accu = evalueaza(model, val_loader)
        print(f"Epoca {epoca + 1}, Loss_antrenare={lossuri_antrenare[-1]}, Loss_validare={val_loss}, Acuratete_validare={valid_accu}")

        if val_loss < cel_mai_bun_loss:
            cel_mai_bun_loss = val_loss
            contor_oprire_prematura = 0
        else:
            # incrementam contorul de oprire prematura daca pierderea nu se imbunatateste
            contor_oprire_prematura += 1
            print(f"Contor early stopping {contor_oprire_prematura}/5")

            # verificam daca am atins 5 iteratii fara imbunatariri si incheiam antrenarea in acest caz
            if contor_oprire_prematura > 4:
                print(f"Oprire prematura. Loss antrenare: {val_loss}. Loss validare: {val_loss}")
                break


labeluri_prezise = []
def testeaza(model, test_loader):
    imagini_test = [] # retinem numele imaginlor pentru a le afisa la final in csv
    with open(f"{prefix_directoare}/test.csv") as inp:
        inp_csv = csv.reader(inp)
        next(inp_csv)
        for _inp in inp_csv:
            imagini_test.append(_inp[0])

    model.eval()
    with torch.no_grad():
        for imagini in test_loader: # facem predictiile pe datele de test
            preziceri = model(imagini)
            # determinam clasa prezisa pentru fiecare imagine
            _, prezise = torch.max(preziceri.data, 1) 
            imagini_test.append(imagini)
            labeluri_prezise.extend(prezise)

    # salvam rezultatele intr-un fisier csv
    with open("predictii_svm.csv", "w") as inp:
        inp.write("Image,Class\n")
        for i in range(len(labeluri_prezise)):
            inp.write(str(imagini_test[i]) + "," + str(labeluri_prezise[i].tolist()) + "\n")


ponderi_clase = calculeaza_ponderile_claselor()
model = ClasaUtila()
o = opti.Adam(model.parameters(), lr=rata_de_invatare, weight_decay=degradarea_ratei_de_invatare)
crit = net.CrossEntropyLoss(weight=ponderi_clase)
antreneaza(model, o)
testeaza(model, test_loader)



m = confusion_matrix(val_etichs, svm_val_preds)
per_class_accuracies = {}

# Calculate the accuracy for each one of our classes
for idx in range(96):
    # True negatives are all the samples that are not our current GT class (not the current row) 
    # and were not predicted as the current class (not the current column)
    true_negatives = num.sum(num.delete(num.delete(m, idx, axis=0), idx, axis=1))
    
    # True positives are all the samples of our current GT class that were predicted as such
    true_positives = m[idx, idx]
    
    # The accuracy for the current class is the ratio between correct predictions to all predictions
    per_class_accuracies[idx] = (true_positives + true_negatives) / num.sum(m)