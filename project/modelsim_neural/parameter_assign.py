assign_file = open('project/modelsim_neural/parameter_assign.txt', 'w')

with open('project/modelsim_neural/layer1_weight.mem') as f:
    layer1_weight = list(map(lambda x: x.strip(), f.readlines()))
    for i, v in enumerate(layer1_weight):
        assign_file.write(f'weights1[{i}] <= 16\'b{v};\n')
            
with open('project/modelsim_neural/layer1_bias.mem') as f:
    layer1_bias = list(map(lambda x: x.strip(), f.readlines()))
    for i, v in enumerate(layer1_bias):
        assign_file.write(f'biases1[{i}] <= 16\'b{v};\n')
  
with open('project/modelsim_neural/layer2_weight.mem') as f:
    layer2_weight = list(map(lambda x: x.strip(), f.readlines()))
    for i, v in enumerate(layer2_weight):
        assign_file.write(f'weights2[{i}] <= 16\'b{v};\n')
        
with open('project/modelsim_neural/layer2_bias.mem') as f:
    layer2_bias = list(map(lambda x: x.strip(), f.readlines()))
    for i, v in enumerate(layer2_bias):
        assign_file.write(f'biases2[{i}] <= 16\'b{v};\n')
        
with open('project/modelsim_neural/layer3_weight.mem') as f:
    layer3_weight = list(map(lambda x: x.strip(), f.readlines()))
    for i, v in enumerate(layer3_weight):
        assign_file.write(f'weights3[{i}] <= 16\'b{v};\n')
        
with open('project/modelsim_neural/layer3_bias.mem') as f:
    layer3_bias = list(map(lambda x: x.strip(), f.readlines()))
    for i, v in enumerate(layer3_bias):
        assign_file.write(f'biases3[{i}] <= 16\'b{v};\n')