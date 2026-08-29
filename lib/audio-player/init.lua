local dfpwm = require('cc.audio.dfpwm')

function play_audio(audio_file, sub_directory)
    local sub_directory = sub_directory or './music/'
    local speaker = peripheral.find('speaker')

    local decoder = dfpwm.make_decoder()
    for chunk in io.lines(sub_directory .. audio_file .. '.dfpwm', 16 * 1024) do
        local buffer = decoder(chunk)

        while not speaker.playAudio(buffer) do
            os.pullEvent('speaker_audio_empty')
        end
    end
end

return { play_audio = play_audio }
