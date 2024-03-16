#encoding: utf-8

models = {
  'ArticleCategory' => 'Categoria de Conteúdo',
  'Article' => 'Conteúdo',
  'Banner' => 'Banner',
  'BannerCategory' => 'Categoria de Banner',
  'Newsletter' => 'Newsletter',
  'Page' => 'Página',
  'PageImage' => 'Imagens para Página',
  'Image'  => 'Imagens para Conteúdo',
  'Localization'  => 'Localização',
  'Phone'  => 'Telefone',
  'EmailCategory'  => 'Categoria de E-mail',
  'EmailContact'  => 'E-mail de Contato',
  'SocialNetwork' => 'Redes Sociais',
  'Video' => 'Vídeo',
  'Blog' => 'Blog',
  'Role' => 'Grupo',
  'User' => 'Usuário',
  'Lottery' => 'Loteria',
  'Quota' => 'Cotas',
  'Member' => 'Clientes'
}

actions = { 'create' => 'adicionar', 'read' => 'visualizar', 'update' => 'editar', 'destroy' => 'remover' }

pages = ['Quem Somos','Valores','Missão','Visão']

article_categories = ['']

banner_categories = [{ name: 'Banners', image_width: 1920, image_height: 400 }]


models.each do |object|
  actions.each do |action|
    Permission.find_or_create_by(object_type: object[0], action_name: action[0]) do |r|
      r.description = "#{action[1].camelize} #{object[1]}"
    end
  end
end

pages.each do |page|
  Page.find_or_create_by(title: page) do |p|
    p.content = 'Falta Conteudo'
  end
end

article_categories.each do |name|
  ArticleCategory.find_or_create_by(name: name)
end

banner_categories.each do |banner|
  BannerCategory.find_or_create_by(banner)
end


%w(Admin Redação Cliente Atendimento).each do |role|
  Role.find_or_create_by(name: role)
end

['Contato'].each do |name|
  EmailCategory.find_or_create_by(name: name)
end

User.find_or_create_by(email: 'redacao@corp.agenciaacerte.com') do |u|
  u.password = '#acer7e2727'
  u.is_active = true
  u.role = Role.where(name: 'Redação').first
end

User.find_or_create_by(email: 'atendimento@agenciaacerte.com') do |u|
  u.password = 'Atend2727*'
  u.is_active = true
  u.role = Role.where(name: 'Atendimento').first
end

namespace :dev do
  User.find_or_create_by(email: 'desenvolvimento@agenciaacerte.com') do |u|
    u.password = '-, 8?Wgc-_j<np#~'
    u.is_active = true
    u.role = Role.where(name: 'Admin').first
    u.is_admin = true
  end
end
