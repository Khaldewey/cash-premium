#encoding: utf-8

models = {
  'Banner' => 'Banner',
  'BannerCategory' => 'Categoria de Banner',
  'Newsletter' => 'Newsletter',
  'Image'  => 'Imagens para Conteúdo',
  'SocialNetwork' => 'Redes Sociais',
  'Blog' => 'Blog',
  'Role' => 'Grupo',
  'User' => 'Usuário',
  'Lottery' => 'Loteria',
  'Member' => 'Clientes'
}

actions = { 'create' => 'adicionar', 'read' => 'visualizar', 'update' => 'editar', 'destroy' => 'remover' }

banner_categories = [{ name: 'Banners', image_width: 1920, image_height: 400 }]


models.each do |object|
  actions.each do |action|
    Permission.find_or_create_by(object_type: object[0], action_name: action[0]) do |r|
      r.description = "#{action[1].camelize} #{object[1]}"
    end
  end
end

banner_categories.each do |banner|
  BannerCategory.find_or_create_by(banner)
end

%w(Admin Redação Cliente Atendimento).each do |role|
  Role.find_or_create_by(name: role)
end

User.find_or_create_by(email: 'redacao@corp.cash.com') do |u|
  u.password = '#mudar123'
  u.is_active = true
  u.role = Role.where(name: 'Redação').first
end

User.find_or_create_by(email: 'atendimento@cash.com') do |u|
  u.password = 'mudar123'
  u.is_active = true
  u.role = Role.where(name: 'Atendimento').first
end

namespace :dev do
  User.find_or_create_by(email: 'desenvolvimento@cash.com') do |u|
    u.password = 'mudar123'
    u.is_active = true
    u.role = Role.where(name: 'Admin').first
    u.is_admin = true
  end
end
