require File.dirname(__FILE__) + '/../spec_helper'

describe 'the base filter class' do
  before  { @base = Rack::PageSpeed::Filters::Base.new(FIXTURES.complex, :foo => 'bar') }
  
  context 'the #method declaration, which can be used to declare a method name which the filter can be called upon' do
    it 'can be called from inside the class' do
      class Boo < Rack::PageSpeed::Filters::Base
        method 'mooers'
      end
      Boo.method.should == 'mooers'
    end
    
    it 'defaults to the class name if not called' do
      class BananaSmoothie < Rack::PageSpeed::Filters::Base; end
      BananaSmoothie.method.should == 'banana_smoothie'      
    end
  end
    
  context 'when instancing' do  
    it 'takes a Nokogiri HTML document as a paramater' do
      @base.document.should == FIXTURES.complex
    end
  
    it 'takes an options hash as a second argument' do
      @base.options[:foo].should == 'bar'
    end
  
    it 'errors out if no argument is passed to the initializer' do
      expect { Rack::PageSpeed::Filters::Base.new }.to raise_error    
    end
  end
  
  context '#file_for returns a File object' do
    before { @base.options.stub(:[]).with(:public).and_return(FIXTURES_PATH) }
    
    it 'for a script' do
      script = FIXTURES.complex.at_css('#mylib')
      @base.send(:file_for, script).stat.size.should == File.size(File.join(FIXTURES_PATH, 'mylib.js'))
    end
    
    it "for a stylesheet" do
      style = FIXTURES.complex.at_css('link')
      @base.send(:file_for, style).stat.size.should == File.size(File.join(FIXTURES_PATH, 'reset.css'))
    end
  end
end