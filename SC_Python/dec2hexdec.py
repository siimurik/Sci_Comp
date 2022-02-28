import sys
 
def FloatToHex(x, k = 16):
    if x < 0: 
        sign = "-"
        x = -x
    else:
        sign = ""
    s = [sign + str(int(x)) + '.']
    x -= int(x)
    for i in range(k):
        y = int(x * 16)
        s.append(hex(y)[2:])
        x = x * 16 - y
    return ''.join(s).rstrip('0')
 
if __name__ == "__main__":
    print(FloatToHex(0.1))
    print(FloatToHex(0.225))
    print(FloatToHex(2.24))
    print(FloatToHex(5))
    print(hex(18))
    print(hex(63))