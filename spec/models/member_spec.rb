require 'rails_helper'

RSpec.describe Member, type: :model do
 
  it 'verificando_se_existe_Member' do 
    expect(defined?(Member)).to eq('constant')
    expect(Member).to be_a(Class)
  end

  it 'validando_ausencia_de_campos_vazios' do 
   member = Member.new 
   expect(false).to eq(member.save)
  end 

  describe '.find_by_ticket' do
    before do
      # Criando membros com tickets

      @member1 = Member.find_or_create_by!(cpf: '123.456.789.10') do |member|
        member.name = 'John Doe'
        member.email = 'john@mail.com'
        member.phone = '(79)99999-8888'
        member.tickets = { '1' => ['123', '456'], '2' => ['789'] }
      end

      @member2 = Member.find_or_create_by!(cpf: '123.456.789.11') do |member|
        member.name = 'Jane Doe'
        member.email = 'jane@mail.com'
        member.phone = '(79)99999-8887'
        member.tickets = { '1' => ['234'], '2' => ['567', '890'] }
      end
    end

    it 'retorna o membro correto para um ticket e loteria válidos' do
      result = Member.find_by_ticket('123', 1)
      expect(result).to eq(@member1)
    end

    it 'retorna nil quando o ticket não existe' do
      result = Member.find_by_ticket('999', 1)
      expect(result).to be_nil
    end

    it 'retorna nil quando a loteria não existe' do
      result = Member.find_by_ticket('123', 3)
      expect(result).to be_nil
    end

    it 'retorna nil quando o ticket não está associado ao membro' do
      result = Member.find_by_ticket('234', 2)
      expect(result).to be_nil
    end
  end
end
