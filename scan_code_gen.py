if __name__ == '__main__':
    KEYS = ' ,abcdefghijklmnopqrstuvwxyz0123456789'
    KEY_CODES = [
            0x29, 0x41,
            0x1c, 0x32, 0x21, 0x23,
            0x24, 0x2b, 0x34, 0x33, 0x43,
            0x3b, 0x42, 0x4b, 0x3a, 0x31,
            0x44, 0x4d, 0x15, 0x2d, 0x1b,
            0x2c, 0x3c, 0x2a, 0x1d, 0x22,
            0x35, 0x1a,
            0x45, 0x16, 0x1e, 0x26, 0x25,
            0x2e, 0x36, 0x3d, 0x3e, 0x46
    ]

    L = len(KEYS)
    for i in range(0, L):
        if KEYS[i] == ' ':
            o = 'SPACE'
        elif KEYS[i] == ',':
            o = 'COMMA'
        else:
            o = KEYS[i]

        print('CMPI R2 %d' % KEY_CODES[i])
        print('BTEQZ INT_TYPIST_PS2_' + o)
        print('NOP')
        print

    for i in range(0, L):
        if KEYS[i] == ' ':
            o = 'SPACE'
        elif KEYS[i] == ',':
            o = 'COMMA'
        else:
            o = KEYS[i]

        print('INT_TYPIST_PS2_' + o + ':')
        print('LI R1 %d' % ord(KEYS[i]))
        print('B INT_TYPIST_PS2_RECEIVE')
        print('NOP')
        print

