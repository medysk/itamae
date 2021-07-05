# Usage

先にプロビジョニングを行うマシンで、ユーザ作成とssh接続・パスワードなしでsudoできるように設定しておく    
SSH接続先のプロビジョニングの場合、公開鍵での接続のみを想定している  
nodesのyml.sampleファイルを編集しsampleを外してyamlを準備する  

`bundle install`  

itamaeをローカルで実行  
`sudo bundle exec itamae local -y nodes/development.yml cook.rb`  
itamaeをリモートで実行  
`bundle exec itamae ssh -y nodes/development.yml -h {host} -p {ssh_port} -u {user} -i {key} cook.rb`  

デバッグオプション  
`-l debug`  

レシピ追加  
`bundle exec itamae g cookbook {name}`  

テスト  
`bundle exec rake ITAMAE_ENV={env} SSH_CONFIG={ssh_config_path} TARGET_HOST={host}`  
ローカルテスト  l
`bundle exec rake ITAMAE_ENV=production`  
リモートテスト(sshコンフィグファイルがある前提)  
`bundle exec rake ITAMAE_ENV=production SSH_CONFIG=~/.ssh/config TARGET_HOST=example.com`  
