describe Jets::Commands::Call do
  let(:call) do
    call = Jets::Commands::Call.new(provided_function_name, event, mute: true)
    allow(call).to receive(:lambda).and_return(null)
    call
  end
  let(:null) { double(:null).as_null_object }

  context "function with dash" do
    let(:provided_function_name) { "posts-controller-index" }
    context "empty event" do
      let(:event) { nil }

      it "puts out response event" do
        call.run
      end
    end

    context "controller event payload" do
      let(:event) { '{"id":"tung"}' }

      it "transforms controller event payload to lambda proxy format" do
        text = call.transformed_event
        event = JSON.load(text)
        expect(event["queryStringParameters"]).to eq("id" => "tung")
      end
    end

    context "job event payload" do
      let(:provided_function_name) { "hard-job-dig" }
      let(:event) { '{"id":"tung"}' }

      it "leaves event payload untouched" do
        text = call.transformed_event
        expect(text).to eq event
      end
    end

    context "payload from a file" do
      let(:provided_function_name) { "hard-job-dig" }
      let(:event) { 'file://payloads/create.json' }

      it "loads the json from a file" do
        text = call.transformed_event
        fixture_payload = IO.read("#{Jets.root}payloads/create.json")
        expect(text).to eq(fixture_payload)
      end
    end
  end

  context "function with underscore" do
    let(:provided_function_name) { "posts_controller-index" }
    context "controller event payload" do
      let(:event) { '{"id":"tung"}' }

      it "transforms controller event payload to lambda proxy format" do
        text = call.transformed_event
        event = JSON.load(text)
        expect(event["queryStringParameters"]).to eq("id" => "tung")
      end
    end
  end
end
