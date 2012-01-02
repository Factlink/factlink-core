module OhmValueReference
  def value_reference(name, model)
    model = Ohm::Model::Wrapper.wrap(model)
    reader = :"#{name}_id"
    writer = :"#{name}_id="

    attributes(self) << reader   unless attributes.include?(reader)

    define_memoized_method(name) do
      model.unwrap[send(reader)]
    end

    define_method(:"#{name}=") do |value|
      cur_val = send("#{name}")
      if cur_val
        unless cur_val == value
          cur_val.take_values(value)
        end
      else
        @_memo.delete(name)
        value.save
        send(writer, value ? value.id : nil)
      end
    end

    define_method(reader) do
      read_local(reader)
    end

    define_method(writer) do |value|
      @_memo.delete(name)
      write_local(reader, value)
    end

  end
end