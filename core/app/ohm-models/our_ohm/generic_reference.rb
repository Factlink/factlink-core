class OurOhm < Ohm::Model
  module GenericReference
    def generic_reference(name)
      reader = :"#{name}_id"
      writer = :"#{name}_id="

      reader_c = :"#{name}_class"
      writer_c = :"#{name}_class="

      attributes(self) << reader   unless attributes.include?(reader)
      attributes(self) << reader_c unless attributes.include?(reader_c)

      index reader
      index reader_c

      define_memoized_method(name) do
        classname = send(reader_c)
        id = send(reader)

        next nil unless classname && id

                #constantize:
        klass = classname.split('::').inject(Kernel) {|x,y|x.const_get(y)}
        if klass == NilClass
          nil
        else
          if klass.ancestors.include? Ohm::Model
            klass[id]
          else
            klass.find(id) # Return the ActiveModel object
          end
        end
      end

      define_method(:"#{name}=") do |value|
        @_memo.delete(name)
        send(writer, value ? value.id : nil)
        send(writer_c, value ? value.class.to_s : nil)
      end

      define_method(reader) do
        read_local(reader)
      end

      define_method(writer) do |value|
        @_memo.delete(name)
        write_local(reader, value)
      end

      define_method(reader_c) do
        read_local(reader_c)
      end

      define_method(writer_c) do |value|
        @_memo.delete(name)
        write_local(reader_c, value)
      end
    end
  end
end
