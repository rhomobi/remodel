require 'helper'

class Puzzle < Remodel::Entity
  has_many :pieces, :class => 'Piece'
end

class Piece < Remodel::Entity
  belongs_to :puzzle
  property :color
end

class TestEntity < Test::Unit::TestCase

  context "has_many" do
    context "collection property" do
      should "exist" do
        puzzle = Puzzle.create
        assert puzzle.respond_to?(:pieces)
      end
    
      should "return an empty list by default" do
        puzzle = Puzzle.create
        assert_equal [], puzzle.pieces
      end
    
      should "return any existing children" do
        puzzle = Puzzle.create
        redis.rpush "#{puzzle.key}:pieces", Piece.create(:color => 'red').key
        redis.rpush "#{puzzle.key}:pieces", Piece.create(:color => 'blue').key
        assert_equal 2, puzzle.pieces.size
        assert_equal Piece, puzzle.pieces[0].class
        assert_equal 'red', puzzle.pieces[0].color
      end
    
      context "create" do
        should "have a create method" do
          puzzle = Puzzle.create
          assert puzzle.pieces.respond_to?(:create)
        end
      
        should "create and store a new child" do
          puzzle = Puzzle.create
          puzzle.pieces.create :color => 'green'
          puzzle.pieces.create :color => 'yellow'
          assert_equal 2, puzzle.pieces.size
          puzzle.reload
          assert_equal 2, puzzle.pieces.size
          assert_equal Piece, puzzle.pieces[1].class
          assert_equal 'yellow', puzzle.pieces[1].color
        end
      end
    end
  end
  
  context "belongs_to" do
    should "have a getter for the parent" do
      piece = Piece.create
      assert piece.puzzle.nil?
    end
  end
  
  context "reload" do
    should "reload all collections" do
      puzzle = Puzzle.create
      piece = puzzle.pieces.create :color => 'black'
      redis.del "#{puzzle.key}:pieces"
      puzzle.reload
      assert_equal [], puzzle.pieces
    end
  end
  
  
end