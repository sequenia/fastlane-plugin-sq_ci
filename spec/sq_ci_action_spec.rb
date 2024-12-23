describe Fastlane::Actions::SqCiAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The sq_ci plugin is working!")

      Fastlane::Actions::SqCiAction.run(nil)
    end
  end
end
