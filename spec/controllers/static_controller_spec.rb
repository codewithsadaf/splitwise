# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:participant) { create(:user) }
  let(:expense) { create(:expense, payor: user, amount: 100) }
  let(:expected_respnse_keys) do
    %i[amounts_owed_by_participants expenses_you_owe_for total_balance total_due_to_you total_you_owe]
  end

  before do
    sign_in user

    create(:expense_share, expense: expense, participant: participant, amount_owed: 50, category: 'owed')
    create(:expense_share, expense: expense, participant: user, amount_owed: 50, category: 'lent')
  end

  describe 'GET #dashboard' do
    it 'assigns @user_expense_stats' do
      get :dashboard

      expect(assigns(:user_expense_stats)).not_to be_nil
      expect(assigns(:user_expense_stats).keys.sort).to eq(expected_respnse_keys)
      expect(assigns(:user_expense_stats)[:total_due_to_you].to_f).to eq(50)
      expect(response).to render_template(:dashboard)
    end
  end

  describe 'GET #person' do
    context 'when the user exists' do
      it 'assigns @expenses_paid_by_current_user and renders the template' do
        get :person, params: { id: participant.id }

        expect(assigns(:expenses_paid_by_current_user)).not_to be_nil
        expect(assigns(:expenses_paid_by_current_user).first.id).to eq(expense.id)
        expect(response).to render_template(:person)
      end
    end

    context 'when the user does not exist' do
      it 'redirects to the root path with a notice' do
        get :person, params: { id: '0' }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('User not found')
      end
    end
  end
end
