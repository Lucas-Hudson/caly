require "test_helper"

module Caly
  describe MicrosoftGraph::Event do
    def setup
      @provider = MicrosoftGraph::Event
      Client.host = @provider::HOST
      Client.token = "token"
    end

    describe "#list" do
      describe "when successful" do
        it "must return an array of Caly::Event instances" do
          stub_request(
            :get, "https://graph.microsoft.com/v1.0/me/calendar/calendarView?endDateTime&startDateTime&top=1000"
          ).to_return_json(body: json_for(:microsoft_graph, :event, :list), status: 200)

          response = @provider.list

          assert response.is_a?(Array)
          assert response.sample.is_a?(Caly::Event)
          assert_equal "microsoft_graph_id", response.sample.id
          assert_equal "microsoft_graph_name", response.sample.name
        end
      end

      describe "when unsuccessful" do
        it_returns_an_error(:microsoft_graph) do
          @provider.list
        end
      end
    end

    describe "#get" do
      describe "when successful" do
        it "must return a Caly::Event instance" do
          id = rand(123)

          stub_request(
            :get, "https://graph.microsoft.com/v1.0/me/calendar/events/#{id}"
          ).to_return_json(body: json_for(:microsoft_graph, :event, :get), status: 200)

          response = @provider.get(id: id)

          assert response.is_a?(Caly::Event)
          assert_equal "microsoft_graph_id", response.id
          assert_equal "microsoft_graph_name", response.name
          assert_equal Time, response.starts_at.class
          assert_equal Time, response.starts_at.class
        end
      end

      describe "when unsuccessful" do
        it_returns_an_error(:microsoft_graph) do
          @provider.get(id: "id")
        end
      end
    end

    describe "#create" do
      describe "when successful" do
        it "must return a Caly::Event instance" do
          stub_request(
            :post, "https://graph.microsoft.com/v1.0/me/calendar/events"
          ).to_return_json(body: json_for(:microsoft_graph, :event, :get), status: 201)

          starts = Time.now
          ends = starts + 3600
          tz = "Europe/Paris"

          response = @provider.create(starts_at: starts, ends_at: ends, start_time_zone: tz, end_time_zone: tz)

          assert response.is_a?(Caly::Event)
          assert_equal "microsoft_graph_id", response.id
          assert_equal "microsoft_graph_name", response.name
        end
      end

      describe "when unsuccessful" do
        it_returns_an_error(:microsoft_graph) do
          starts = Time.now
          ends = starts + 3600
          tz = "Europe/Paris"

          @provider.create(starts_at: starts, ends_at: ends, start_time_zone: tz, end_time_zone: tz)
        end
      end
    end

    describe "#update" do
      describe "when successful" do
        it "must return a Caly::Event instance" do
          id = rand(123)

          stub_request(
            :patch, "https://graph.microsoft.com/v1.0/me/calendar/events/#{id}"
          ).to_return_json(body: json_for(:microsoft_graph, :event, :get), status: 200)

          response = @provider.update(id: id, name: "name")

          assert response.is_a?(Caly::Event)
          assert_equal "microsoft_graph_id", response.id
          assert_equal "microsoft_graph_name", response.name
        end
      end

      describe "when unsuccessful" do
        it_returns_an_error(:microsoft_graph) do
          @provider.update(id: rand(123), name: "name")
        end
      end
    end

    describe "#delete" do
      describe "when successful" do
        it "must return a Caly::Event instance" do
          id = rand(123)

          stub_request(
            :delete,
            "https://graph.microsoft.com/v1.0/me/calendar/events/#{id}"
          ).to_return_json(status: 204)

          response = @provider.delete(id: id)

          assert_equal true, response
        end
      end

      describe "when unsuccessful" do
        it_returns_an_error(:microsoft_graph) do
          @provider.delete(id: rand(123))
        end
      end
    end
  end
end
