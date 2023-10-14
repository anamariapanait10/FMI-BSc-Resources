import math


class MyNaiveBayes:
    def mean(self, nums):
        return sum(nums) / float(len(nums))

    def std_dev(self, nums):
        m = self.mean(nums)
        sigma = math.sqrt(sum([pow(x - m, 2) for x in nums]) / float(len(nums) - 1))
        return sigma

    def mean_and_std_dev(self, data):
        info = [(self.mean(attr), self.std_dev(attr)) for attr in zip(*data) if self.mean(attr) != 0 and self.std_dev(attr)]
        return info

    def separate_by_class(self, X_train, y_train):
        dict = {}
        for i in range(len(X_train)):
            if y_train[i] not in dict:
                dict[y_train[i]] = []
            dict[y_train[i]].append(X_train[i])
        return dict

    def mean_and_std_dev_for_class(self, X_train, y_train):
        info = {}
        dict = self.separate_by_class(X_train, y_train)
        for class_val, instances in dict.items():
            info[class_val] = self.mean_and_std_dev(instances)
        return info

    def calculate_gaussian_probability(self, x, mean, stdev):
        expo = math.exp(-(math.pow(x - mean, 2) / (2 * math.pow(stdev, 2))))
        return (1 / (math.sqrt(2 * math.pi) * stdev)) * expo

    def calculate_class_probabilities(self, info, test):
        probabilities = {}
        for class_val, class_summaries in info.items():
            probabilities[class_val] = 1
            for i in range(len(class_summaries)):
                mean, std_dev = class_summaries[i]
                x = test[i]
                probabilities[class_val] *= self.calculate_gaussian_probability(x, mean, std_dev)
        return probabilities

    def predict(self, info, test):
        probabilities = self.calculate_class_probabilities(info, test)
        best_label, best_prob = None, -1
        for class_val, probability in probabilities.items():
            if best_label is None or probability > best_prob:
                best_prob = probability
                best_label = class_val
        return best_label

    def get_predictions(self, info, test):
        predictions = []
        for i in range(len(test)):
            result = self.predict(info, test[i])
            predictions.append(result)
        return predictions
    
    def implemented_classifier(self, X_train, y_train, X_test):
        info = self.mean_and_std_dev_for_class(X_train, y_train)
        return self.get_predictions(info, X_test)
