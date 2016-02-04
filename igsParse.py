import argparse

# Get arguments
def getArguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('file',
                        action  = 'store',
                        help    = 'Data file to parse')
    return parser.parse_args()

# Main function
def main():
    args = getArguments()
    data = open(args.file, 'r')
    f = open(args.file + '.csv', 'wb')
    
    # Process header
    line = data.readline()
    epochs = int(line[32:39])
    f.write('{},{},{}\r\n'.format(line[3:7], line[8:10], line[11:13]))
    # f.write('Epochs,{}\r\n'.format(epochs))
    # f.write('Format,{},{},{},{}\r\n'.format(line[40:45], line[46:51], line[52:55], line[56:60]))
    line = data.readline()
    # f.write('GPS Time,{},{},{}\r\n'.format(line[3:7], line[8:23], line[39:44]))
    line = data.readline()
    sats = int(line[4:6])
    for i in range(17):
        b = 3*(i+4)
        a = b - 2
        f.write('{},'.format(line[a:b]))
    line = data.readline()
    for i in range(17):
        b = 3*(i+4)
        a = b - 2
        id = int(line[a:b])
        if id != 0:
            f.write('{},'.format(id))
    f.seek(-1, 1)
    f.write('\r\n')
    # f.write('Satellites,{}\r\n'.format(sats))
    for i in range(18):
        line = data.readline()
    f.write('{},{}\r\n'.format(epochs, sats))
    
    # Process epochs
    for epoch in range(epochs):
        line = data.readline()
        # f.write('{},{},{},{},{},{}\r\n'.format(line[3:7], line[8:10], line[11:13], line[14:16], line[17:19], line[20:31]))
        for sat in range(sats):
            line = data.readline()
            # f.write('{},{},{},{}\r\n'.format(line[2:4], line[4:18], line[18:32], line[32:46]))
            f.write('{},{},{}\r\n'.format(line[4:18], line[18:32], line[32:46]))
    
    f.close()
    data.close()

if __name__ == '__main__':
    main()

