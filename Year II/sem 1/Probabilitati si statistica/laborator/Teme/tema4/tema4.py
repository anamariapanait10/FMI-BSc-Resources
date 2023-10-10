import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import GaussianNB
from my_naive_bayes import MyNaiveBayes
from sklearn.metrics import accuracy_score

Data = pd.read_csv("spam_ham_dataset.csv")

# convert text to vector
count_vectorizer = CountVectorizer()
X = count_vectorizer.fit_transform(Data["text"]).toarray()

X_train, X_test, y_train, y_test = train_test_split(X, Data["label_num"].tolist(), test_size=0.25, random_state=109)

gnb = GaussianNB()
gnb.fit(X_train, y_train)
y_pred = gnb.predict(X_test)
print("Accuracy of implemented Naive Bayes:", accuracy_score(y_test, y_pred))

# compare it with my implementation
mnb = MyNaiveBayes()
y_pred = mnb.implemented_classifier(X_train, y_train, X_test)
print("Accuracy of my implementation for Naive Bayes:", accuracy_score(y_test, y_pred))