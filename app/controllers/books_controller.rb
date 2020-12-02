class BooksController < ApplicationController

  before_action :authenticate_user!
  before_action :baria_user, only: [:edit, :update, :destroy]

  def show
  	@book = Book.find(params[:id])
    @user = @book.user
    @newbook = Book.new
  end

  def index
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @newbook = Book.new
  end

  def create
  	@newbook = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @newbook.user_id = current_user.id
  	if @newbook.save #入力されたデータをdbに保存する。
  		redirect_to book_path(@newbook), notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
  		@books = Book.all
  		render 'index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end

  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to @book, notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render "edit"
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body, :user)
  end

  def baria_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

end
