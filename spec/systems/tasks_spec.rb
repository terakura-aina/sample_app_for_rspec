require 'rails_helper'

RSpec.describe 'tasks', type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    describe 'タスクページ確認' do
      context 'タスクの新規作成登録ページへアクセス' do
        it '新規登録ページへのアクセスが失敗する' do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end

      context 'タスクの編集ページへアクセス' do
        it 'タスク編集ページへのアクセスが失敗する' do
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { sign_in_as(user) }

    describe 'タスクの新規作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          visit new_task_path
          fill_in 'Title', with: 'title'
          fill_in 'Content', with: 'content'
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content 'Title: title'
          expect(page).to have_content 'Content: content'
          expect(page).to have_content 'Status: todo'
          expect(page).to have_content 'Deadline:'
          expect(current_path).to eq '/tasks/1'
        end
      end

      context 'titleが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'content'
          click_button 'Create Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end

      context 'titleが同じ' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          other_task = create(:task)
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: 'content'
          click_button 'Create Task'
          expect(page).to have_content 'Title has already been taken'
          expect(current_path).to eq tasks_path
        end
      end
    end

    describe 'タスクの編集' do
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }

      context 'フォームの入力値が正常' do
        it 'タスクの編集に成功する' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'update_title'
          fill_in 'Content', with: 'update_content'
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content 'Task was successfully updated.'
          expect(page).to have_content 'Title: update_title'
          expect(page).to have_content 'Content: update_content'
          expect(page).to have_content 'Status: todo'
          expect(page).to have_content 'Deadline:'
          expect(current_path).to eq task_path(task)
        end
      end

      context 'titleが未入力' do
        it 'タスクの編集に失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'update_content'
          click_button 'Update Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end

      context '登録済みのtitleを入力' do
        it 'タスクの編集に失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with:other_task.title
          fill_in 'Content', with: 'update_content'
          click_button 'Update Task'
          expect(page).to have_content 'Title has already been taken'
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスクの削除' do
      let!(:task) { create(:task, user: user) }

      it 'タスクの削除が成功する' do
        visit tasks_path
        click_link 'Destroy'
        expect(page.accept_confirm).to eq 'Are you sure?'
        expect(page).to have_content 'Task was successfully destroyed.'
        expect(current_path).to eq tasks_path
      end
    end
  end
end
