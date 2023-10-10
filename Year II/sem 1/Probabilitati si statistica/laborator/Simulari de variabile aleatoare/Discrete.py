

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm

def discrete(N, values, probabilities):
    uniform_values = np.random.uniform(0, 1, size = N)
    discrete_values = []

    for i in range(N):
      if uniform_values[i] < probabilities[0]:
         discrete_values.append(values[0])
      else:
        j = 1
        probabilities_sum = probabilities[0]
        while j < len(values) - 1:
           if uniform_values[i] < probabilities_sum + probabilities[j]:
             discrete_values.append(values[j])
             break
           else:
              probabilities_sum += probabilities[j]
              j += 1
           if j == len(values) - 1:
              discrete_values.append(values[j])
    
    fig, ax = plt.subplots()
  
    cmap = cm.get_cmap(name='rainbow')
    print(discrete_values)
    for i in range(len(probabilities)):
      P = []
      p_counter = 0
      for j in range(len(discrete_values)):
        if discrete_values[j] == values[i]:
          p_counter += 1
        P.append(p_counter/(j+1))
      ax.annotate('  p' + str(i) + "= " + str(probabilities[i]), 
            xy=(10000, probabilities[i]), 
            xytext=(10000, probabilities[i]), 
            arrowprops = dict(facecolor='black', shrink=0.1, width=1))
      ax.plot(range(N), P, color = cmap(i))



def main():

    N = 10000
    values = [1, 2, 3, 4, 5]
    probabilities = [0.2, 0.3, 0.2, 0.1, 0.2]
    
    discrete(N, values, probabilities)

if __name__ == "__main__":
    main()

