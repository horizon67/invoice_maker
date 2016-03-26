# utf8mb4を使用するため下記の対応が必要
# @see https://github.com/rails/rails/issues/9855
module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter
      NATIVE_DATABASE_TYPES[:string] = { :name => "varchar", :limit => 191 }
    end
  end
end
