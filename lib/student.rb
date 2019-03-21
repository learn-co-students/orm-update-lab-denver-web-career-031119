require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_accessor :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade)
    @name = name
    @grade = grade
    @id = nil
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students(
        id INT,
        name TEXT,
        grade TEXT,
        PRIMARY KEY (id)
      );
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students
      (name, grade)
      VALUES (?,?)
    SQL
    if self.id
      self.update
    else
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() from STUDENTS")[0][0]
    end

  end

  def self.create(name, grade)
    self.new(name,grade).save
  end

  def self.new_from_db(row)
    # binding.pry
    yeet = self.new(row[1],row[2])
    yeet.id = row[0]
    yeet
    # binding.pry
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = (?)
    SQL
    yeet = DB[:conn].execute(sql, name)[0]
    self.new_from_db(yeet)
    # binding.pry
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ? , grade = ?
      WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
