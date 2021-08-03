# frozen_string_literal: true

# Install Docker-ce

# === Method  for Ubuntu ===
def prepar_4_installation_via_https
  %w[
    apt-transport-https
    ca-certificates
    curl
    software-properties-common
  ].each do |pkg|
    package pkg do
      action :install
    end
  end
end

def install_docker
  execute 'install gpg key' do
    command 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -' # rubocop:disable Layout/LineLength
  end

  execute 'add apt repository' do
    only_if 'apt-key fingerprint 0EBFCD88 | grep -q "9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88"' # rubocop:disable Layout/LineLength
    command 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"' # rubocop:disable Layout/LineLength
  end

  execute 'apt update'

  package 'docker-ce' do
    action :install
  end

  execute 'call it whithout sudo' do
    command "usermod -aG docker #{node['user_name']}"
  end
end
# ==========================

case node['distro']
when 'ubuntu'
  prepar_4_installation_via_https
  install_docker
when 'ol8'
  execute 'add docker repo' do
    not_if 'dnf repolist | grep docker-ce-stable'
    command 'dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo'
  end

  %w[docker-ce docker-ce-cli containerd.io].each do |pkg|
    package pkg do
      action :install
      options '--allowerasing'
    end
  end
end

service 'docker' do
  # WSL2の場合はサービスを起動しない。サービス起動は手動または別の方法で行う
  not_if 'uname -r | grep -q "microsoft"'
  action %i[enable restart]
end

# Install Docker-Compose

compose_uri = 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)' # rubocop:disable Layout/LineLength
compose_dir = '/usr/local/bin/docker-compose'

execute 'install docker-compose' do
  not_if '[ -f /usr/local/bin/docker-compose ]'
  command <<~SH
    curl -L #{compose_uri} -o #{compose_dir}
    chmod +x #{compose_dir}
  SH
end

execute 'docker-compose completion' do
  not_if '[ -f /usr/local/share/zsh/site-functions/_docker-compose ]'
  command %(curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose > /usr/local/share/zsh/site-functions/_docker-compose) # rubocop:disable Layout/LineLength
end
