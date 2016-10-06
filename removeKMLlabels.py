# Import libraries
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
    file = open(args.file, 'r')
    out = open(args.file.split('.')[0] + '_nolabels.kml', 'wb')
    
    for line in file:
        if '<name>Point' in line:
            continue
        out.write(line)

if __name__ == '__main__':
    main()

