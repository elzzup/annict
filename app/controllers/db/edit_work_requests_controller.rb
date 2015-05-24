class Db::EditWorkRequestsController < Db::ApplicationController
  before_action :set_work, only: [:new, :create]
  before_action :set_edit_request, only: [:edit, :update]

  def new
    @form = EditRequest::WorkForm.new

    if @work.present?
      @form.attrs = @work
      @form.work = @work
    end
  end

  def create(edit_request_work_form)
    @form = EditRequest::WorkForm.new(edit_request_work_form)
    @form.work = @work
    @form.user = current_user

    if @form.save
      flash[:notice] = "編集リクエストを送信しました"
      redirect_to db_edit_request_path(@form.edit_request_id)
    else
      render :new
    end
  end

  def edit
    @form = EditRequest::WorkForm.new
    @form.edit_request = @edit_request
  end

  def update(edit_request_work_form)
    @form = EditRequest::WorkForm.new(edit_request_work_form)
    @form.edit_request_id = @edit_request.id
    @form.user = @edit_request.user
    @form.work = @edit_request.resource

    if @form.save
      flash[:notice] = "編集リクエストを更新しました"
      redirect_to db_edit_request_path(@form.edit_request_id)
    else
      render :edit
    end
  end

  private

  def set_work
    return unless params.has_key?(:work_id)

    @work = Work.find(params[:work_id])
  end

  def set_edit_request
    @edit_request = EditRequest.find(params[:id])
  end
end