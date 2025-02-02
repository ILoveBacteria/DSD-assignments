INPUT_SIZE = 784
HIDDEN1_SIZE = 64
HIDDEN2_SIZE = 32
OUTPUT_SIZE = 10

assign_file = open('project/modelsim_neural/parameter_assign.txt', 'w')

with open('project/modelsim_neural/layer1_weight.mem') as f:
    layer1_weight = list(map(lambda x: x.strip(), f.readlines()))
    index = 0
    for i in range(HIDDEN1_SIZE):
        for j in range(INPUT_SIZE):
            assign_file.write(f'assign weights1[{i}][{j}] = 16\'b{layer1_weight[index]};\n')
            index += 1
            
with open('project/modelsim_neural/layer1_bias.mem') as f:
    layer1_bias = list(map(lambda x: x.strip(), f.readlines()))
    for i in range(HIDDEN1_SIZE):
        assign_file.write(f'assign biases1[{i}] = 16\'b{layer1_bias[i]};\n')
        
with open('project/modelsim_neural/layer2_weight.mem') as f:
    layer2_weight = list(map(lambda x: x.strip(), f.readlines()))
    index = 0
    for i in range(HIDDEN2_SIZE):
        for j in range(HIDDEN1_SIZE):
            assign_file.write(f'assign weights2[{i}][{j}] = 16\'b{layer2_weight[index]};\n')
            index += 1
            
with open('project/modelsim_neural/layer2_bias.mem') as f:
    layer2_bias = list(map(lambda x: x.strip(), f.readlines()))
    for i in range(HIDDEN2_SIZE):
        assign_file.write(f'assign biases2[{i}] = 16\'b{layer2_bias[i]};\n')
        
with open('project/modelsim_neural/layer3_weight.mem') as f:
    layer3_weight = list(map(lambda x: x.strip(), f.readlines()))
    index = 0
    for i in range(OUTPUT_SIZE):
        for j in range(HIDDEN2_SIZE):
            assign_file.write(f'assign weights3[{i}][{j}] = 16\'b{layer3_weight[index]};\n')
            index += 1
            
with open('project/modelsim_neural/layer3_bias.mem') as f:
    layer3_bias = list(map(lambda x: x.strip(), f.readlines()))
    for i in range(OUTPUT_SIZE):
        assign_file.write(f'assign biases3[{i}] = 16\'b{layer3_bias[i]};\n')
    