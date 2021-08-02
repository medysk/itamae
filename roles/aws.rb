# frozen_string_literal: true

recipes = [
  'asdf',        # awscli, eksctlのインストールに必要
  'awscli',
  'nodejs',      # amplify_cliのインストールに必要
  'amplify_cli',
  'eksctl',
  # 'python',      # awscli-localのインストールに必要
  # 'awscli-local',
]

include_recipes recipes
