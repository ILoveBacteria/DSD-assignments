def encrypt(v, k):
    v0, v1 = v[0], v[1]
    sum_ = 0
    delta = 0x9E3779B9
    k0, k1, k2, k3 = k

    for _ in range(32):
        sum_ += delta
        v0 += ((v1 << 4) + k0) ^ (v1 + sum_) ^ ((v1 >> 5) + k1)
        v0 &= 0xFFFFFFFF  # Ensure 32-bit
        v1 += ((v0 << 4) + k2) ^ (v0 + sum_) ^ ((v0 >> 5) + k3)
        v1 &= 0xFFFFFFFF  # Ensure 32-bit

    return v0, v1

plaintext1 = [0x01234567, 0x89ABCDEF]
plaintext2 = [0xFEDCBA98, 0x76543210]
key = [0x00010203, 0x04050607, 0x08090A0B, 0x0C0D0E0F]

encrypted = encrypt(plaintext1, key)
print(hex(encrypted[0]), hex(encrypted[1])) 

encrypted = encrypt(plaintext2, key)
print(hex(encrypted[0]), hex(encrypted[1]))  
