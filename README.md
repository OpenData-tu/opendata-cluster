# Getting Started

# Installing tools
You need to install `kops` and `kubectl` cli tools first. Mainly you will need to follow this [documentation](https://github.com/kubernetes/kops/blob/master/docs/aws.md).
Probably you will need to install [AWS Command Line Interface](https://aws.amazon.com/cli/).

# akops command
To create aws ec2 spot instance you will need to use the binary file `akops`. You can find it at `./bin/akops` add the directory to your PATH environment variable to be able to use it.
Important! the akops is too big for github. You can get it [here](https://drive.google.com/file/d/0B7v1s06naHzIYW1SS2JDMW8ycGc/view?usp=sharing) instead.

# Config
All script related configures are in `./config/` directory. You will need to rename the file `aws_key.sh.sample` to `aws_key.sh` and then fill it with your kops AWS user access key ID & Secret.

# Make file
Use `make help` command to get a list of the most import commands. Anyway, you will need to read into the `Makefile` for the full list of commands.

# Important node
- Be aware that this tool is still under heavy development and operating it may not be a smooth experience.
- Be careful not to publish any sensitive information on Github.
