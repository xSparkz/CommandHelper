register_command('tournamentjoin', 

    array(
    
        description: 'Join a tournament',
        usage: '/tournamentjoin <tournamentName>',
        permission: 'tournament.join',
        noPermMsg: 'Sorry you don\'t have permission to use this command.',

        executor: closure(@alias, @sender, @args) {
            @plr = player()
            assign(@cooldown, 15)
            assign(@lastUsedTournamentJoin, import(@plr."lastUsedTournamentJoin"))
            if(@lastUsedTournamentJoin + @cooldown > time() / 1000,
                assign(@timeleft, subtract(add(@lastUsedTournamentJoin, @cooldown), divide(time(),1000)))
                tmsg(@plr,concat('§c[§4', Error, '§c] §7You must wait another §6', round(@timeleft), ' §7seconds before you can leave another tournament!'))
                die()
            )
            if (array_size(@args) != 1) {
                msg(''.color(RED).color(BOLD).'Improper Usage!');
                msg(''.color(RED).'Usage: /tournamentjoin <tournamentName>');
                die(); # No need to go further					
            }
            
            @tournamentName = to_lower(@args[0])
            @tournamentURL = @tournamentName.'_omnivs'
            @puuid = puuid(@plr,true)

            # @challongeKey gets initialized behind the scenes when doing this include
            include('/home/minecraft/server/plugins/CommandHelper/includes/challongeKey.ms')

            tmsg(@plr,color(red).'Joing to tournament '.@tournamentName.'...')
            @url = 'https://api.challonge.com/v1/tournaments/'.@tournamentURL.'/participants.json'
            http_request(@url, array(
                method: 'POST',
                headers: array(
                 // The content type isn't set automatically if we send a string via params,
                 // so we have to set this manually to application/json here, since we're sending
                 // json data. Other data types may have different MIME types.
                 'Content-Type': 'application/json'
                ),   params: array(
                 'api_key': @challongeKey,
                 'participant[name]': @plr,
                 'participant[misc]': @puuid,
                ),
                success: closure(@response){
                if(@response['responseCode'] != 200){
                    tmsg(@plr,color(red).'Error!')
                    @error = json_decode(@response['body'])
                    foreach(@error in @error['errors']){
                        tmsg(@plr,color(red).@error)
                    }
                    die()
                }
                export(@plr."lastUsedTournamentJoin", time() / 1000)
                @confirmation = json_decode(@response['body'])
                store_value('tournament.'.@puuid.@tournamentName.'participantID',@confirmation['participant']['id'])
                broadcast(@plr.color(RED).' has checked into the '.@tournamentName.' tournament!'.color(WHITE).' /tournamentjoin '.@tournamentName)
            }));
        }
    )
)
