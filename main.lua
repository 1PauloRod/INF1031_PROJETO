W, H = 900, 700
alturaJogador = 70
larguraJogador = 50
pos_jogadorX = W/2
pos_jogadorY = H - alturaJogador

function love.load ()
  love.window.setMode(W, H)
  w, h = love.graphics.getDimensions()
  love.window.setTitle('Powerglide')
  imgCarro = love.graphics.newImage('carroPrincipal.png')
  love.graphics.setBackgroundColor(0,0.75,0)

  --CENÁRIO
  criaLinhaTempoMax = 0.3
  criaLinhaTempo = criaLinhaTempoMax
  velLinha = 400
  linhas = {}


  --CARRO INIMIGO

  criaCarroTempoMax = 1
  criaCarroTempo = criaCarroTempoMax
  velCarro = 250
  carros = {}
  imgInimigo = love.graphics.newImage('carro3.png')

  --VIDA E PONTUAÇÃO

  fonte = love.graphics.newFont('Arial.ttf', 20)
  vivo = true
  pontos = 0

  -- TELA INICIAL
  abreTelaInicial = false
  telaInicial = love.graphics.newImage('telaJogo.png')
  inicialX = 0
  inicialY = 0
  button = false


  --PAUSAR O JOGO
  pause = false

  --AUDIO JOGO
  somBatida = love.audio.newSource('batida_carro.wav', 'static')
  somPolicia = love.audio.newSource('policia.wav', 'static')
  musica = love.audio.newSource('musica.wav', 'static')
  musica:play()
  musica:setLooping(true)
  som = true
end


function love.update(dt)
  if not pause then
    iniciaJogo()
    criaLinha(dt)
    criaCarroInimigo(dt)
    criaJogador(dt)
    colisao()
    colisaoNaTela()
    pontuacao()
    reiniciaJogo()
  end
end


function iniciaJogo ()
  if abreTelaInicial and not vivo then
    vivo = true
  end
end


function criaLinha (dt)
  criaLinhaTempo = criaLinhaTempo - (1 * dt)
  if criaLinhaTempo < 0 then
    criaLinhaTempo = criaLinhaTempoMax

    --CRIA UMA LINHA
    linha = {x = w/2, y = -10}
    table.insert(linhas, linha)
  end
  --ATUALIZA LINHA POSICAO
  for i, linha in ipairs(linhas) do
    linha.y = linha.y + (velLinha * dt)

    if linha.y > h+250 then
      table.remove(linhas, i)
    end
  end

end


function criaCarroInimigo(dt)
  criaCarroTempo = criaCarroTempo - (1 * dt)
  if criaCarroTempo < 0 then
    criaCarroTempo = criaCarroTempoMax

    --CRIA UM CARRO
    numeroAleatorio = math.random(w/4 + 20, (w-(w/3)+30))
    carro = {x = numeroAleatorio, y = -10}
    table.insert(carros, carro)
  end
  --ATUALIZA CARRO POSICAO
  for i, carro in ipairs(carros) do
    carro.y = carro.y + (velCarro * dt)

    if carro.y > h + 250 then
      table.remove(carros, i)
    end
  end
end

function criaJogador(dt)
  -- JOGADOR E MOVIMENTACAO
  if love.keyboard.isDown('right') then pos_jogadorX = pos_jogadorX + 250*dt end
  if love.keyboard.isDown('left') then pos_jogadorX = pos_jogadorX - 250*dt end
  if love.keyboard.isDown('up') then pos_jogadorY = pos_jogadorY - 250*dt  end
  if love.keyboard.isDown('down') then pos_jogadorY = pos_jogadorY + 250*dt end
end

function colisao ()
  for i = 1, #carros do
    if verificaColisao(carros[i].x, carros[i].y , imgInimigo:getWidth(), imgInimigo:getHeight(),
     pos_jogadorX - (imgCarro:getWidth()/2) ,pos_jogadorY,imgCarro:getWidth(), imgCarro:getHeight()) and vivo then
      table.remove(carro, i)
      vivo = false
      abreTelaInicial = false
      if som then
        somBatida:stop()
        somBatida:play()
      else
        somBatida:stop()
      end
    end
  end
end


function verificaColisao (x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 - 10 < x2 + w2 and (x2 + w2) - 10 < x1 + w1 and y1 + 30 < y2 + h2 and y2 + 30 < y1 + h1
end


function colisaoNaTela ()
  if pos_jogadorY < imgCarro:getHeight()/2 then
    pos_jogadorY = imgCarro:getHeight()/2
  end
  if pos_jogadorY > h - imgCarro:getHeight()/2 then
    pos_jogadorY = h - imgCarro:getHeight()/2
  end
  if pos_jogadorX < w/4 + imgCarro:getWidth()/2 then
    pos_jogadorX = w/4 + imgCarro:getWidth()/2
  end
  if pos_jogadorX > (w/4 + w/2) - imgCarro:getWidth()/2 then
    pos_jogadorX = (w/4 + w/2) - imgCarro:getWidth()/2
  end
end


function pontuacao ()
  if vivo then
    pontos = pontos + 1
    criaCarroTempoMax = criaCarroTempoMax - 0.001/2
    if criaCarroTempoMax < 0.43 then
      criaCarroTempoMax = 0.42
    end
  end
end


function reiniciaJogo()
  if love.keyboard.isDown('return') then
    button = true
    if not vivo then
      carros = {}
      criaCarroTempoMax = 1
      criaCarroTempo = criaCarroTempoMax
      pos_jogadorX = w/2
      pos_jogadorY = H - alturaJogador
      vivo = true
      pontos = 0
      abreTelaInicial = true
    end
  end
end


local function GAME ()

  --CONSTRUINDO CENÁRIO

  love.graphics.setColor(0.4, 0.4, 0.4)
  love.graphics.rectangle('fill', w/4,h, w/2,-h)
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle('line', w/4,h, w/2,-h)
  --MOVIMENTACAO DO CENÁRIO
  tamLinhaX = 25
  tamLinhaY = 50
  for i, linha in ipairs(linhas) do
  love.graphics.setColor(196, 196, 0)
  love.graphics.rectangle('fill', linha.x-tamLinhaX/2, linha.y, tamLinhaX,tamLinhaY)
  end



  --INIMIGOS
  love.graphics.setColor(196,196,0)
  for i, carro in ipairs(carros) do
  love.graphics.setColor(0.75, 0.75, 0.75)
  love.graphics.draw(imgInimigo, carro.x, carro.y,0, 1, 1, imgInimigo:getWidth()/2, imgInimigo:getHeight()/2)
  end



  --PONTUACAO
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(fonte)
  love.graphics.print('Score: '..pontos, 0, 0)
  love.graphics.print('Aperte p para pausar!', w - 200, h/(h/10))
  love.graphics.print('Aperte Esc para sair! ', inicialX,h - 30)
  love.graphics.print('Aperte m para mutar!', w-200, h - 30)

  --GAME OVER
  if vivo then
    love.graphics.setColor(0.75, 0.75, 0.75)
    love.graphics.draw(imgCarro,pos_jogadorX, pos_jogadorY,0 ,1, 1, imgCarro:getWidth()/2, imgCarro:getHeight()/2)
  else
    somPolicia:stop()
    love.graphics.draw(telaInicial, inicialX - 50, inicialY)
    love.graphics.print("Aperte Enter para recomeçar! ", 0, 0)
    love.graphics.print('Aperte Esc para sair! ', inicialX,h - 30)
    love.graphics.print('Score: '..pontos, w/2 - 50, h - 100)
    love.graphics.print('Aperte m para mutar!', w-200, h - 30)
  end

end

function love.keyreleased (key)
  if key == 'p'  then
    pause = not pause
  end
  if key == 'escape' then
    love.event.quit()
  end
  if key == 'm' then
    som = not som
    if not som then
      musica:stop()
    else
      musica:play()

    end
  end
end


function love.draw ()
  if button == false then
    love.graphics.draw(telaInicial, inicialX - 50, inicialY)
    love.graphics.setFont(fonte, 54)
    love.graphics.print('Aperte Enter para começar! ', inicialX,inicialY)
    love.graphics.print('Aperte Esc para sair! ', inicialX,h - 30)
    love.graphics.print('Aperte m para mutar!', w-200, h - 30)
  else
    GAME()
    if som then
      somPolicia:play()
      somPolicia:setLooping(true)
    else
      somPolicia:stop()
    end
  end
end
