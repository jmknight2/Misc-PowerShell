Function Play-RPSLS {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('Rock', 'Paper', 'Scissors', 'Lizard', 'Spock')]
        [string]$PlayerChoice
    )

    Begin {
        Clear-Host
    }

    Process {
        $Choices = @('Rock', 'Paper', 'Scissors', 'Lizard', 'Spock')
        $rand = Get-Random -Minimum 0 -Maximum $Choices.Count

        $CompChoice = $Choices[$rand]

        Write-Host "===========================================`n"

        Switch($PlayerChoice) {
            Rock {
                if($CompChoice -eq 'Rock') {
                    Write-Host -ForegroundColor Yellow "It's a tie!"
                } elseif($CompChoice -eq 'Paper') {
                    Write-Host -ForegroundColor Red "You lose!"
                    "(Paper covers rock)"
                } elseif($CompChoice -eq 'Scissors') {
                    Write-Host -ForegroundColor Green "You win!"
                    "(Rock crushes scissors)"
                } elseif($CompChoice -eq 'Lizard') {
                    Write-Host -ForegroundColor Green "You win!"
                    "(Rock crushes lizard)"
                } elseif($CompChoice -eq 'Spock') {
                    Write-Host -ForegroundColor Red "You lose!"
                    "(Spock vaporizes rock)"
                } 
            }

            Paper {
                if($CompChoice -eq 'Rock') {
                    Write-Host -ForegroundColor Green "You win!"
                    "(Paper covers rock)"
                } elseif($CompChoice -eq 'Paper') {
                    Write-Host -ForegroundColor Yellow "It's a tie!"
                } elseif($CompChoice -eq 'Scissors') {
                    Write-Host -ForegroundColor Red "You lose!"
                    "(Scissors cut paper)"
                } elseif($CompChoice -eq 'Lizard') {
                    Write-Host -ForegroundColor Red "You lose!"
                    "(Lizard eats paper)"
                } elseif($CompChoice -eq 'Spock') {
                    Write-Host -ForegroundColor Green "You win!"
                    "(Paper disproves Spock)"
                }
            }

            Scissors {
                if($CompChoice -eq 'Rock') {
                    Write-Host -ForegroundColor Red "You lose!"
                    "(Rock crushes scissors)"
                } elseif($CompChoice -eq 'Paper') {
                    Write-Host -ForegroundColor Green "You win!"
                    "(Scissors cut paper)"
                } elseif($CompChoice -eq 'Scissors') {
                    Write-Host -ForegroundColor Yellow "It's a tie!"
                } elseif($CompChoice -eq 'Lizard') {
                    Write-Host -ForegroundColor Green "You win!"
                    "(Scissors decapitates lizard)"
                } elseif($CompChoice -eq 'Spock') {
                    Write-Host -ForegroundColor Red "You lose!"
                    "(Spock smashes scissors)"
                }
            }

            Lizard {
                if($CompChoice -eq 'Rock') {
                    Write-Host -ForegroundColor Red "You lose!"
                    "(Rock crushes lizard)"
                } elseif($CompChoice -eq 'Paper') {
                    Write-Host -ForegroundColor Green "You win!"
                    "(Lizard eats paper)"
                } elseif($CompChoice -eq 'Scissors') {
                    Write-Host -ForegroundColor Red "You lose!"
                    "(Scissors decapitates lizard)"
                } elseif($CompChoice -eq 'Lizard') {
                    Write-Host -ForegroundColor Yellow "It's a tie"
                } elseif($CompChoice -eq 'Spock') {
                    Write-Host -ForegroundColor Green "You win!"
                    "(Lizard poisons Spock)"
                }
            
            }

            Spock {
                if($CompChoice -eq 'Rock') {
                    Write-Host -ForegroundColor Green "You win!"
                    "(Spock vaporizes rock)"
                } elseif($CompChoice -eq 'Paper') {
                    Write-Host -ForegroundColor Red "You lose!"
                    "(Paper disproves Spock)"
                } elseif($CompChoice -eq 'Scissors') {
                    Write-Host -ForegroundColor Green "You win!"
                    "(Spock smashes scissors)"
                } elseif($CompChoice -eq 'Lizard') {
                    Write-Host -ForegroundColor Red "You lose!"
                    "(Lizard poisons Spock)"
                } elseif($CompChoice -eq 'Spock') {
                    Write-Host -ForegroundColor Yellow "It's a tie!"
                    "(Double the Spockiness...)"
                }                
            }
        }
    }

    End {
        [PSCustomObject]@{
            'You Chose'=$PlayerChoice
            'Computer Chose'=$CompChoice
        }

        Write-Host "===========================================`n"
    }
}