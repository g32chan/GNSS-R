# Import libraries
import argparse
import os

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
    out = open(args.file + '.csv', 'wb')
    
    for line in file:
        temp = line.strip().split(' ');
        for x in temp:
            out.write(x)
            out.write(',')
        out.write('\r\n')

if __name__ == '__main__':
    main()

