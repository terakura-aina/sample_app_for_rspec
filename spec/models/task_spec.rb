require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it '全て入力されている時有効であること' do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    it 'titleが空の時無効であること' do
      task_without_title = build(:task, title: nil)
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to eq ["can't be blank"]
    end

    it 'statusが空の時無効であること' do
      task = build(:task, status: nil)
      expect(task).to be_invalid
      expect(task.errors[:status]).to eq ["can't be blank"]
    end

    it 'titleが同じ時無効であること' do
      task = create(:task)
      task_with_duplicated_title = build(:task, title: task.title)
      expect(task_with_duplicated_title).to be_invalid
      expect(task_with_duplicated_title.errors[:title]).to eq ["has already been taken"]
    end

    it 'titleが違う時有効であること' do
      task = create(:task)
      task_with_another_title = build(:task, title: 'another_title')
      expect(task_with_another_title).to be_valid
      expect(task_with_another_title.errors).to be_empty
    end
  end
end
