require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do end

    it 'titleが空の時無効であること' do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'statusが空の時無効であること' do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it 'titleが同じ時無効であること' do
      FactoryBot.create(:task, title: 'test')
      task = FactoryBot.build(:task, title: 'test')
      task.valid?
      expect(task.errors[:title]).to include('has already been taken')
    end

    it 'titleが違う時有効であること' do
      FactoryBot.create(:task, title: 'test')
      task = FactoryBot.build(:task, title: 'test2')
      task.valid?
      expect(task).to be_valid
    end
  end
end
