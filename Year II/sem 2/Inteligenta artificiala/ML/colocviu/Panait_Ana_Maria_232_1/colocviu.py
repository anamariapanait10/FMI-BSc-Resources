




# facem predictiile pe datele de test si le afisam intr un csv
svm_test_preds = _svm_model.predict(test_imgs)
with open("Panait_Ana_Maria_232_subiect[i]_solutia_j.csv", "w") as sc:
    sc.write("Image,Class\n")
    for i in range(len(svm_test_preds)):
        sc.write(f"{test_nume_imgs[i]},{svm_test_preds[i]}\n")