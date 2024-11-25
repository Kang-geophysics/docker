# Layer 0: 밑그림이 되는 IMAGE 불러오기. (https://hub.docker.com/)
FROM ubuntu:22.04
# Layer 1: 밑그림 위에 설치할 프로그램 설치 명령어 작성
RUN apt-get update \
	&& apt-get install -y \
	ca-certificates \
	build-essential \
	procps \
	curl \
	file \
	git \
	vim \
	libgl1-mesa-glx \
	libegl1-mesa \
	libxrandr2 \
	libxss1 \
	libxcursor1 \
	libxcomposite1 \
	libasound2 \
	libxi6 \
	libxtst6 \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*
# Layer 2: Install Homebrew
RUN curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
RUN	echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc && \
	echo 'export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH' >> ~/.bashrc && \
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
	brew install zsh tmux neovim fzf lsd
# Layer 3: 밑그림 위에 설치할 프로그램 설정 명령어 작성
RUN git clone https://github.com/Kang-geophysics/dotfile.git ~/dotfile && \
	mv ~/dotfile/.zshrc ~/ && \
	mv ~/dotfile/.zimrc ~/ && \
	mv ~/dotfile/.tmux.conf ~/ && \
	rm -rf ~/dotfile && \
	git clone https://github.com/Kang-geophysics/nvim-starter-pack.git ~/.config/nvim
# Layer 4:
RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh && \
	sh Anaconda3-2024.10-1-Linux-x86_64.sh -b && \
	rm Anaconda3-2024.10-1-Linux-x86_64.sh && \
	echo 'export PATH=~/anaconda3/bin:$PATH' >> ~/.bashrc && \
	echo 'export PATH=~/anaconda3/bin:$PATH' >> ~/.zshrc && \
	export PATH=~/anaconda3/bin:$PATH && \
	conda update -n base -c defaults conda -y && \
	conda create -n tf python=3.10 -y && \
	conda install -n tf -c conda-forge ipykernel -y && \
	conda install -n tf -c conda-forge tensorflow=2.11 -y && \
	conda init bash && \
	conda init zsh