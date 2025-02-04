# feature 28x28 -> 784 bits
feature = '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110000000000000000000000011111100000000000000000000011000000000000000000000000001000000000000000000000000001100000000000000000000000000100000000000000000000000000010000000000000000000000000001000000000000000000000000000101111111000000000000000000010100000111000000000000000001110000000110000000000000000110000000001000000000000000011000000000100000000000000000100000000010000000000000000010000000001000000000000000000110000001000000000000000000001111111000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
feature = feature[::-1]
array_32_bit = [feature[i:i+32] for i in range(0, len(feature), 32)]
array_32_bit = list(map(lambda x: hex(int(x, 2)), array_32_bit))
# print hex format
print(', '.join(array_32_bit))